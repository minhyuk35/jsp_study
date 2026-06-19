<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.hat.HatDAO, com.hatshop.hat.HatDTO, com.hatshop.util.Logger,
                 org.json.JSONObject, org.json.JSONArray, java.net.URLEncoder, java.util.List" %>
<%
    response.setHeader("Cache-Control", "no-store");
    String CTX = request.getContextPath();
    String q = request.getParameter("q");
    JSONObject resultJson = new JSONObject();

    if (q == null || q.trim().isEmpty()) {
        resultJson.put("items", new JSONArray());
        resultJson.write(response.getWriter());
        return;
    }
    q = q.trim();
    if (q.length() > 100) q = q.substring(0, 100);

    try {
        HatDAO hatDAO = new HatDAO();
        List<HatDTO> list = hatDAO.getHatList(null, q, 1, 8);
        JSONArray items = new JSONArray();
        for (HatDTO h : list) {
            JSONObject item = new JSONObject();
            item.put("name", h.getHatName());
            item.put("price", h.getHatPrice());
            String rawImg = h.getHatImage();
            String imgUrl;
            if (rawImg != null && !rawImg.trim().isEmpty()) {
                imgUrl = CTX + "/image?src=" + URLEncoder.encode(rawImg, "UTF-8");
            } else {
                imgUrl = CTX + "/images/no-image.png";
            }
            item.put("image", imgUrl);
            item.put("url", "/hat/detail?hatNo=" + h.getHatNo());
            items.put(item);
        }
        resultJson.put("items", items);
        resultJson.write(response.getWriter());
    } catch (Exception e) {
        Logger.error(this.getClass(), "상품 검색(챗봇) 오류: q=" + q, e);
        response.setStatus(500);
        resultJson.put("items", new JSONArray());
        resultJson.put("error", "검색 중 오류가 발생했습니다.");
        resultJson.write(response.getWriter());
    }
%>
