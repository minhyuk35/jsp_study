<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.hat.HatDTO, com.hatshop.util.HtmlUtils" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/error/403.jsp"); return;
    }

    HatDTO hat = (HatDTO) request.getAttribute("hat");
    if (hat == null) {
        response.sendRedirect(request.getContextPath() + "/error/404.jsp"); return;
    }

    String ctx = request.getContextPath();
    String flashError   = (String) session.getAttribute("flashError");
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    session.removeAttribute("flashError");
    session.removeAttribute("flashSuccess");

    String curImageUrl = hat.getHatImage() != null ? hat.getHatImage() : "";
    String imgSrc = (!curImageUrl.isEmpty())
        ? ctx + "/image?src=" + java.net.URLEncoder.encode(curImageUrl, "UTF-8")
        : ctx + "/images/no-image.png";
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
.admin-wrap    { max-width: 760px; margin: 40px auto; padding: 0 16px 60px; }
.admin-breadcrumb { display: flex; align-items: center; gap: 6px; font-size: .82rem; color: var(--ink-soft); margin-bottom: 20px; }
.admin-breadcrumb a:hover { color: var(--accent); }
.admin-card    { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; padding: 28px 32px; }
.admin-title   { font-size: 1.2rem; font-weight: 700; margin-bottom: 24px; padding-bottom: 14px; border-bottom: 1px solid var(--line); display: flex; align-items: center; gap: 10px; }
.hat-no-badge  { font-size: .75rem; font-weight: 400; color: var(--ink-soft); background: var(--ph-a); padding: 2px 8px; border-radius: 20px; }
.img-preview   { width: 120px; height: 120px; object-fit: cover; border: 1px solid var(--line); border-radius: 4px; margin-top: 8px; background: var(--ph-a); }
.img-preview-empty { width: 120px; height: 120px; border: 1px dashed var(--line); border-radius: 4px; margin-top: 8px; display: flex; align-items: center; justify-content: center; font-size: .78rem; color: var(--ink-soft); }
.admin-actions { display: flex; gap: 10px; margin-top: 24px; padding-top: 18px; border-top: 1px solid var(--line); }
.delete-zone   { margin-top: 20px; padding: 20px 24px; border: 1px solid var(--red); border-radius: 4px; background: rgba(200,16,46,.04); }
.delete-zone h3 { font-size: .95rem; color: var(--red); margin-bottom: 6px; }
.delete-zone p  { font-size: .83rem; color: var(--ink-soft); margin-bottom: 12px; }
</style>

<main class="main-content">
<div class="container">
<div class="admin-wrap">

  <nav class="admin-breadcrumb">
    <a href="<%= ctx %>/admin/">대시보드</a>
    <span>›</span>
    <a href="<%= ctx %>/admin/hatList.jsp">상품 관리</a>
    <span>›</span>
    <span>상품 수정</span>
  </nav>

  <% if (flashError   != null) { %><div class="alert alert-error"  ><%= HtmlUtils.escape(flashError)   %></div><% } %>
  <% if (flashSuccess != null) { %><div class="alert alert-success"><%= HtmlUtils.escape(flashSuccess) %></div><% } %>

  <div class="admin-card">
    <h1 class="admin-title">
      상품 수정 <span class="hat-no-badge">No. <%= hat.getHatNo() %></span>
    </h1>

    <form id="editForm" action="<%= ctx %>/admin/hat/edit" method="post"
          onsubmit="return validateEdit(this)">
      <input type="hidden" name="hatNo"    value="<%= hat.getHatNo() %>">
      <input type="hidden" name="action"   value="update">

      <div class="form-group">
        <label>상품명 <span style="color:var(--red)">*</span></label>
        <input type="text" name="hatName" class="form-control"
               value="<%= HtmlUtils.escape(hat.getHatName()) %>" maxlength="100" autofocus>
      </div>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:0 20px;">
        <div class="form-group">
          <label>카테고리 <span style="color:var(--red)">*</span></label>
          <select name="hatCategory" class="form-control">
            <option value="">선택하세요</option>
            <%
              String[] cats = {"볼캡","버킷햇","베레모","페도라","스냅백"};
              for (String c : cats) {
                String sel = c.equals(hat.getHatCategory()) ? " selected" : "";
            %>
            <option value="<%= HtmlUtils.escape(c) %>"<%= sel %>><%= HtmlUtils.escape(c) %></option>
            <% } %>
          </select>
        </div>
        <div class="form-group">
          <label>가격 (원) <span style="color:var(--red)">*</span></label>
          <input type="number" name="hatPrice" class="form-control"
                 value="<%= hat.getHatPrice() %>" min="0" step="100">
        </div>
      </div>

      <div class="form-group">
        <label>재고 수량 <span style="color:var(--red)">*</span></label>
        <input type="number" name="hatStock" class="form-control"
               value="<%= hat.getHatStock() %>" min="0" style="max-width:180px;">
      </div>

      <div class="form-group">
        <label>이미지 URL <span style="font-size:.78rem;color:var(--ink-soft)">(비워두면 기존 이미지 유지)</span></label>
        <input type="text" name="hatImageUrl" id="hatImageUrl" class="form-control"
               value="<%= HtmlUtils.escape(curImageUrl) %>"
               oninput="previewUrl(this.value)">
        <div id="previewWrap" style="margin-top:8px;">
          <% if (!curImageUrl.isEmpty()) { %>
          <img src="<%= imgSrc %>" class="img-preview"
               onerror="this.src='<%= ctx %>/images/no-image.png'" alt="현재 이미지">
          <% } else { %>
          <div class="img-preview-empty">이미지 없음</div>
          <% } %>
        </div>
      </div>

      <div class="form-group">
        <label>상품 설명</label>
        <textarea name="hatDesc" class="form-control" rows="4"
                  style="resize:vertical"><%= HtmlUtils.escape(hat.getHatDesc() != null ? hat.getHatDesc() : "") %></textarea>
      </div>

      <div class="admin-actions">
        <button type="submit" class="btn btn-primary">수정 저장</button>
        <a href="<%= ctx %>/hat/detail?hatNo=<%= hat.getHatNo() %>" class="btn btn-secondary" target="_blank">상품 보기</a>
        <a href="<%= ctx %>/admin/hatList.jsp" class="btn btn-secondary" style="margin-left:auto">목록</a>
      </div>
    </form>
  </div>

  <div class="delete-zone">
    <h3>상품 삭제</h3>
    <p>삭제 후 복구할 수 없습니다.</p>
    <form action="<%= ctx %>/admin/hat/edit" method="post"
          onsubmit="return confirm('<%= HtmlUtils.escape(hat.getHatName()) %> 상품을 삭제하시겠습니까?')">
      <input type="hidden" name="hatNo"  value="<%= hat.getHatNo() %>">
      <input type="hidden" name="action" value="delete">
      <button type="submit" class="btn btn-danger">이 상품 삭제</button>
    </form>
  </div>

</div>
</div>
</main>

<script>
function previewUrl(url) {
  var wrap = document.getElementById('previewWrap');
  if (!url || !url.startsWith('http')) {
    wrap.innerHTML = '<div class="img-preview-empty">미리보기</div>';
    return;
  }
  wrap.innerHTML = '<img src="' + url.replace(/"/g,'') + '" class="img-preview" onerror="this.parentNode.innerHTML=\'<div class=\\\'img-preview-empty\\\'>URL을 확인하세요</div>\'">';
}

function validateEdit(form) {
  if (!form.hatName.value.trim()) { alert('상품명을 입력하세요.'); form.hatName.focus(); return false; }
  if (!form.hatCategory.value)    { alert('카테고리를 선택하세요.'); form.hatCategory.focus(); return false; }
  var price = parseInt(form.hatPrice.value);
  if (isNaN(price) || price <= 0) { alert('가격을 올바르게 입력하세요.'); form.hatPrice.focus(); return false; }
  return true;
}
</script>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
