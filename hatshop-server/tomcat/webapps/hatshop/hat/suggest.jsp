<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.util.Logger, com.hatshop.db.DBConn, org.json.JSONObject, org.json.JSONArray,
                 java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet,
                 java.util.List, java.util.ArrayList, java.util.LinkedHashSet, java.util.Set" %>
<%!
    /* 레벤슈타인 거리(편집거리) — 오타 보정용 */
    private int levenshtein(String a, String b) {
        a = a.toLowerCase(); b = b.toLowerCase();
        int[] dp = new int[b.length() + 1];
        for (int j = 0; j <= b.length(); j++) dp[j] = j;
        for (int i = 1; i <= a.length(); i++) {
            int prev = dp[0];
            dp[0] = i;
            for (int j = 1; j <= b.length(); j++) {
                int temp = dp[j];
                if (a.charAt(i - 1) == b.charAt(j - 1)) {
                    dp[j] = prev;
                } else {
                    dp[j] = 1 + Math.min(prev, Math.min(dp[j], dp[j - 1]));
                }
                prev = temp;
            }
        }
        return dp[b.length()];
    }
%>
<%
    response.setHeader("Cache-Control", "no-store");
    JSONObject resultJson = new JSONObject();
    JSONArray suggestions = new JSONArray();

    String q = request.getParameter("q");
    if (q == null) q = "";
    q = q.trim();

    if (q.isEmpty()) {
        resultJson.put("suggestions", suggestions);
        resultJson.write(response.getWriter());
        return;
    }
    if (q.length() > 50) q = q.substring(0, 50);

    String[] categories = {"볼캡", "버킷햇", "베레모", "페도라", "스냅백"};

    try {
        Connection conn = DBConn.getConnection();
        List<String> hatNames = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement("SELECT DISTINCT hat_name FROM hat");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) hatNames.add(rs.getString("hat_name"));
        }

        String qLower = q.toLowerCase();
        Set<String> added = new LinkedHashSet<>();

        /* 1) 카테고리 직접 일치 */
        for (String cat : categories) {
            if (added.size() >= 8) break;
            if (cat.toLowerCase().contains(qLower) && added.add(cat)) {
                JSONObject item = new JSONObject();
                item.put("text", cat);
                item.put("type", "category");
                suggestions.put(item);
            }
        }

        /* 2) 상품명 직접 일치 */
        for (String name : hatNames) {
            if (added.size() >= 8) break;
            if (name.toLowerCase().contains(qLower) && added.add(name)) {
                JSONObject item = new JSONObject();
                item.put("text", name);
                item.put("type", "product");
                suggestions.put(item);
            }
        }

        /* 3) 직접 일치가 부족하면 오타 보정 (레벤슈타인 거리 기반) */
        if (added.size() < 5) {
            int threshold = q.length() <= 2 ? 1 : 2;

            /* 후보 토큰 모음: 카테고리 + 상품명을 공백으로 분리한 단어들 */
            Set<String> tokenVocab = new LinkedHashSet<>();
            for (String cat : categories) tokenVocab.add(cat);
            for (String name : hatNames) {
                for (String tok : name.split("\\s+")) {
                    if (!tok.isEmpty()) tokenVocab.add(tok);
                }
            }

            final String qForSort = q;
            List<String> corrected = new ArrayList<>();
            for (String token : tokenVocab) {
                if (levenshtein(q, token) <= threshold) corrected.add(token);
            }
            /* 거리 짧은 순으로 정렬 */
            corrected.sort((a, b) -> levenshtein(qForSort, a) - levenshtein(qForSort, b));

            for (String token : corrected) {
                if (added.size() >= 8) break;
                boolean isCategory = false;
                for (String cat : categories) if (cat.equals(token)) { isCategory = true; break; }

                if (isCategory) {
                    if (added.add(token)) {
                        JSONObject item = new JSONObject();
                        item.put("text", token);
                        item.put("type", "category");
                        item.put("corrected", true);
                        suggestions.put(item);
                    }
                } else {
                    /* 해당 토큰을 포함하는 상품명 1~2개 제시 */
                    int cnt = 0;
                    for (String name : hatNames) {
                        if (added.size() >= 8 || cnt >= 2) break;
                        if (name.contains(token) && added.add(name)) {
                            JSONObject item = new JSONObject();
                            item.put("text", name);
                            item.put("type", "product");
                            item.put("corrected", true);
                            suggestions.put(item);
                            cnt++;
                        }
                    }
                }
            }
        }

        resultJson.put("suggestions", suggestions);
        resultJson.write(response.getWriter());

    } catch (Exception e) {
        Logger.error(this.getClass(), "상품 자동완성 오류: q=" + q, e);
        response.setStatus(500);
        resultJson.put("suggestions", new JSONArray());
        resultJson.put("error", "자동완성 처리 중 오류가 발생했습니다.");
        resultJson.write(response.getWriter());
    }
%>
