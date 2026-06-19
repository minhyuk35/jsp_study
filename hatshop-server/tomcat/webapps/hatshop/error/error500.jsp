<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ page import="com.hatshop.util.StringUtil" %>
<%
    String CTX = request.getContextPath();
    Integer statusCode = (Integer)  request.getAttribute("javax.servlet.error.status_code");
    String  errMessage = (String)   request.getAttribute("javax.servlet.error.message");
    String  requestUri = (String)   request.getAttribute("javax.servlet.error.request_uri");
    Throwable errEx    = (Throwable) request.getAttribute("javax.servlet.error.exception");
    if (errEx == null) errEx = exception;

    String safeMsg  = (errEx != null && errEx.getMessage() != null) ? StringUtil.escapeHtml(errEx.getMessage()) : "";
    String safeUri  = (requestUri != null) ? StringUtil.escapeHtml(requestUri) : "";
    String safeType = (errEx != null) ? StringUtil.escapeHtml(errEx.getClass().getName()) : "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>500 서버 오류 - HATSHOP</title>
<link rel="stylesheet" href="<%=CTX%>/css/style.css">
<style>
  .error-page {
    min-height: 100vh; display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    padding: 40px 20px; text-align: center;
  }
  .error-icon {
    width: 80px; height: 80px; border-radius: 50%;
    background: rgba(220,53,69,.08); border: 2px solid rgba(220,53,69,.3);
    display: inline-flex; align-items: center; justify-content: center;
    margin-bottom: 24px;
  }
  .error-icon svg {
    width: 40px; height: 40px; stroke: #ff6b6b;
    fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round;
  }
  .error-code  { font-size: 5rem; font-weight: 900; color: #ff6b6b; line-height: 1; margin-bottom: 12px; }
  .error-title { font-size: 1.4rem; font-weight: 700; margin-bottom: 12px; }
  .error-desc  { color: var(--text-muted); line-height: 1.7; margin-bottom: 32px; max-width: 400px; }
  .btn-home {
    display: inline-block; padding: 13px 36px;
    background: var(--accent); color: #1a1a1a;
    border-radius: 8px; font-weight: 700; text-decoration: none;
    transition: opacity .2s; margin-bottom: 40px;
  }
  .btn-home:hover { opacity: .88; }
  .dev-info {
    text-align: left; max-width: 600px; width: 100%;
    background: rgba(220,53,69,.05); border: 1px solid rgba(220,53,69,.2);
    border-radius: 8px; overflow: hidden;
  }
  .dev-info summary {
    padding: 12px 18px; cursor: pointer; font-size: .85rem;
    color: #ff6b6b; user-select: none; list-style: none;
  }
  .dev-info-body { padding: 0 18px 16px; }
  .dev-row { margin-bottom: 10px; }
  .dev-label { font-size: .75rem; color: var(--text-muted); margin-bottom: 3px; }
  .dev-val {
    font-size: .82rem; background: var(--bg-primary);
    border: 1px solid var(--border); border-radius: 4px;
    padding: 8px 12px; word-break: break-all; white-space: pre-wrap;
    font-family: 'Consolas', monospace; max-height: 200px; overflow-y: auto;
  }
</style>
</head>
<body>
<main class="error-page">
  <div class="error-icon">
    <svg viewBox="0 0 24 24">
      <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
      <line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
    </svg>
  </div>

  <div class="error-code">500</div>
  <h1 class="error-title">서버 오류가 발생했습니다</h1>
  <p class="error-desc">
    요청 처리 중 예상치 못한 오류가 발생했습니다.<br>
    잠시 후 다시 시도해 주시거나 관리자에게 문의하세요.
  </p>

  <a href="<%=CTX%>/" class="btn-home">홈으로 돌아가기</a>

  <details class="dev-info">
    <summary>개발자 정보 (오류 상세)</summary>
    <div class="dev-info-body">
      <% if (!safeUri.isEmpty()) { %>
      <div class="dev-row">
        <div class="dev-label">요청 URI</div>
        <div class="dev-val"><%=safeUri%></div>
      </div>
      <% } %>
      <% if (!safeType.isEmpty()) { %>
      <div class="dev-row">
        <div class="dev-label">예외 유형</div>
        <div class="dev-val"><%=safeType%></div>
      </div>
      <% } %>
      <% if (!safeMsg.isEmpty()) { %>
      <div class="dev-row">
        <div class="dev-label">오류 메시지</div>
        <div class="dev-val"><%=safeMsg%></div>
      </div>
      <% } %>
      <% if (errEx != null) {
           java.io.StringWriter sw = new java.io.StringWriter();
           errEx.printStackTrace(new java.io.PrintWriter(sw));
           String trace = StringUtil.escapeHtml(sw.toString()); %>
      <div class="dev-row">
        <div class="dev-label">스택 트레이스</div>
        <div class="dev-val"><%=trace%></div>
      </div>
      <% } %>
    </div>
  </details>
</main>
</body>
</html>
