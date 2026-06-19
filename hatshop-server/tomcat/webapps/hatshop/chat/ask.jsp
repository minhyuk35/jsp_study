<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.util.Logger, org.json.JSONObject, org.json.JSONArray,
                 java.net.http.HttpClient, java.net.http.HttpRequest, java.net.http.HttpResponse,
                 java.net.URI, java.time.Duration, java.io.InputStream, java.util.Properties" %>
<%
    response.setHeader("Cache-Control", "no-store");

    String message = request.getParameter("message");
    JSONObject resultJson = new JSONObject();

    if (message == null || message.trim().isEmpty()) {
        response.setStatus(400);
        resultJson.put("reply", "");
        resultJson.put("error", "메시지를 입력해주세요.");
        resultJson.write(response.getWriter());
        return;
    }
    message = message.trim();
    if (message.length() > 1000) message = message.substring(0, 1000);

    String apiKey = null;
    String model = "gemini-2.5-flash";
    try {
        Properties props = new Properties();
        InputStream is = getClass().getClassLoader().getResourceAsStream("gemini.properties");
        if (is != null) {
            props.load(is);
            is.close();
            apiKey = props.getProperty("gemini.api.key");
            String m = props.getProperty("gemini.model");
            if (m != null && !m.trim().isEmpty()) model = m.trim();
        }
    } catch (Exception e) {
        Logger.error(this.getClass(), "gemini.properties 로드 오류", e);
    }

    if (apiKey == null || apiKey.trim().isEmpty()) {
        resultJson.put("reply", "현재 AI 상담 기능이 설정되어 있지 않습니다. '고객센터 문의'를 이용해주시면 빠르게 답변드리겠습니다.");
        resultJson.write(response.getWriter());
        return;
    }

    String systemPrompt =
        "당신은 모자 전문 쇼핑몰 'HATSHOP'의 친절한 고객 상담 챗봇입니다. " +
        "배송, 교환/환불, 사이즈, 결제, 회원 혜택 등 쇼핑몰 이용과 관련된 질문에 한국어로 간결하고 친절하게 답변하세요. " +
        "환불은 신청 후 영업일 기준 3~5일 내(회사 사정에 따라 변동 가능)에 처리됩니다. " +
        "쇼핑몰과 무관한 질문에는 도와드리기 어렵다고 정중히 안내하세요. 답변은 3~4문장 이내로 간결하게 작성하세요.";

    try {
        JSONObject part = new JSONObject();
        part.put("text", systemPrompt + "\n\n사용자 질문: " + message);
        JSONObject content = new JSONObject();
        content.put("parts", new JSONArray().put(part));
        JSONObject body = new JSONObject();
        body.put("contents", new JSONArray().put(content));

        String url = "https://generativelanguage.googleapis.com/v1beta/models/" + model +
                     ":generateContent?key=" + apiKey;

        HttpClient client = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(10)).build();
        HttpRequest httpReq = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofSeconds(15))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(body.toString(), java.nio.charset.StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> httpResp = client.send(httpReq, HttpResponse.BodyHandlers.ofString());

        if (httpResp.statusCode() != 200) {
            Logger.error(this.getClass(), "Gemini API 오류 응답: status=" + httpResp.statusCode() + " body=" + httpResp.body());
            resultJson.put("reply", "죄송합니다, 지금은 답변하기 어렵습니다. 잠시 후 다시 시도하거나 고객센터로 문의해주세요.");
            resultJson.write(response.getWriter());
            return;
        }

        JSONObject geminiResp = new JSONObject(httpResp.body());
        String replyText = null;
        JSONArray candidates = geminiResp.optJSONArray("candidates");
        if (candidates != null && candidates.length() > 0) {
            JSONObject cand0 = candidates.getJSONObject(0);
            JSONObject cContent = cand0.optJSONObject("content");
            if (cContent != null) {
                JSONArray parts = cContent.optJSONArray("parts");
                if (parts != null && parts.length() > 0) {
                    replyText = parts.getJSONObject(0).optString("text", null);
                }
            }
        }

        if (replyText == null || replyText.trim().isEmpty()) {
            replyText = "죄송합니다, 답변을 생성하지 못했습니다. 다시 한 번 질문해주시거나 고객센터로 문의해주세요.";
        }
        resultJson.put("reply", replyText.trim());
        resultJson.write(response.getWriter());

    } catch (Exception e) {
        Logger.error(this.getClass(), "Gemini API 호출 오류: message=" + message, e);
        resultJson.put("reply", "죄송합니다, 지금은 답변하기 어렵습니다. 잠시 후 다시 시도하거나 고객센터로 문의해주세요.");
        resultJson.write(response.getWriter());
    }
%>
