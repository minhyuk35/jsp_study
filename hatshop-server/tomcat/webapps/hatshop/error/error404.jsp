<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String CTX = request.getContextPath();
    String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>404 페이지 없음 - HATSHOP</title>
<link rel="stylesheet" href="<%=CTX%>/css/style.css">
<style>
  .error-page {
    min-height: 100vh; display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    padding: 40px 20px; text-align: center;
  }
  .error-number {
    font-size: 8rem; font-weight: 900; line-height: 1; margin-bottom: 8px;
    background: linear-gradient(135deg, var(--accent) 0%, rgba(229,185,78,.4) 100%);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
  }
  .error-title { font-size: 1.4rem; font-weight: 700; margin-bottom: 12px; }
  .error-desc  { color: var(--text-muted); line-height: 1.7; margin-bottom: 32px; max-width: 420px; }
  .btn-row { display: flex; gap: 10px; justify-content: center; flex-wrap: wrap; }
  .btn-home {
    padding: 13px 32px; background: var(--accent); color: #1a1a1a;
    border-radius: 8px; font-weight: 700; text-decoration: none; transition: opacity .2s;
  }
  .btn-home:hover { opacity: .88; }
  .btn-back, .btn-shop {
    padding: 13px 24px; background: transparent; border: 1px solid var(--border);
    color: var(--text-muted); border-radius: 8px; text-decoration: none;
    transition: border-color .2s, color .2s;
  }
  .btn-back:hover, .btn-shop:hover { border-color: var(--accent); color: var(--accent); }
</style>
</head>
<body>
<main class="error-page">
  <div class="error-number">404</div>
  <h1 class="error-title">페이지를 찾을 수 없습니다</h1>
  <p class="error-desc">
    요청하신 페이지가 존재하지 않거나, 주소가 변경되었거나<br>
    일시적으로 사용할 수 없는 상태입니다.
  </p>

  <div class="btn-row">
    <a href="<%=CTX%>/"        class="btn-home">홈으로 돌아가기</a>
    <a href="<%=CTX%>/hat/list" class="btn-shop">모자 쇼핑하기</a>
    <a href="javascript:history.back()" class="btn-back">이전 페이지</a>
  </div>
</main>
</body>
</html>
