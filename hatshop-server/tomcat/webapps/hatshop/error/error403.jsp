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
<title>403 접근 금지 - HATSHOP</title>
<link rel="stylesheet" href="<%=CTX%>/css/style.css">
<style>
  .error-page {
    min-height: 100vh; display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    padding: 40px 20px; text-align: center;
  }
  .error-icon {
    width: 80px; height: 80px; border-radius: 50%;
    background: rgba(229,185,78,.1); border: 2px solid rgba(229,185,78,.4);
    display: inline-flex; align-items: center; justify-content: center;
    margin-bottom: 24px;
  }
  .error-icon svg {
    width: 40px; height: 40px; stroke: var(--accent);
    fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round;
  }
  .error-code  { font-size: 5rem; font-weight: 900; color: var(--accent); line-height: 1; margin-bottom: 12px; }
  .error-title { font-size: 1.4rem; font-weight: 700; margin-bottom: 12px; }
  .error-desc  { color: var(--text-muted); line-height: 1.7; margin-bottom: 32px; max-width: 400px; }
  .btn-row { display: flex; gap: 10px; justify-content: center; flex-wrap: wrap; }
  .btn-home {
    padding: 13px 32px; background: var(--accent); color: #1a1a1a;
    border-radius: 8px; font-weight: 700; text-decoration: none; transition: opacity .2s;
  }
  .btn-home:hover { opacity: .88; }
  .btn-back {
    padding: 13px 24px; background: transparent; border: 1px solid var(--border);
    color: var(--text-muted); border-radius: 8px; text-decoration: none;
    transition: border-color .2s, color .2s;
  }
  .btn-back:hover { border-color: var(--accent); color: var(--accent); }
</style>
</head>
<body>
<main class="error-page">
  <div class="error-icon">
    <svg viewBox="0 0 24 24">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
      <line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/>
    </svg>
  </div>

  <div class="error-code">403</div>
  <h1 class="error-title">접근 권한이 없습니다</h1>
  <p class="error-desc">
    이 페이지를 보려면 관리자 권한이 필요합니다.<br>
    일반 계정으로는 접근할 수 없는 페이지입니다.
  </p>

  <div class="btn-row">
    <a href="<%=CTX%>/" class="btn-home">홈으로 돌아가기</a>
    <a href="javascript:history.back()" class="btn-back">이전 페이지</a>
  </div>
</main>
</body>
</html>
