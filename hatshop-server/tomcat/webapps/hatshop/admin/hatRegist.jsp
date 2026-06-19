<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/error/403.jsp"); return;
    }
    String ctx = request.getContextPath();
    String flashError   = (String) session.getAttribute("flashError");
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    session.removeAttribute("flashError");
    session.removeAttribute("flashSuccess");
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
.admin-wrap    { max-width: 760px; margin: 40px auto; padding: 0 16px 60px; }
.admin-breadcrumb { display: flex; align-items: center; gap: 6px; font-size: .82rem; color: var(--ink-soft); margin-bottom: 20px; }
.admin-breadcrumb a:hover { color: var(--accent); }
.admin-card    { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; padding: 28px 32px; }
.admin-title   { font-size: 1.2rem; font-weight: 700; margin-bottom: 24px; padding-bottom: 14px; border-bottom: 1px solid var(--line); }
.img-preview   { width: 120px; height: 120px; object-fit: cover; border: 1px solid var(--line); border-radius: 4px; margin-top: 8px; background: var(--ph-a); }
.img-preview-empty { width: 120px; height: 120px; border: 1px dashed var(--line); border-radius: 4px; margin-top: 8px; display: flex; align-items: center; justify-content: center; font-size: .78rem; color: var(--ink-soft); }
.admin-actions { display: flex; gap: 10px; margin-top: 24px; padding-top: 18px; border-top: 1px solid var(--line); }
</style>

<main class="main-content">
<div class="container">
<div class="admin-wrap">

  <nav class="admin-breadcrumb">
    <a href="<%= ctx %>/admin/">대시보드</a>
    <span>›</span>
    <a href="<%= ctx %>/admin/hatList.jsp">상품 관리</a>
    <span>›</span>
    <span>상품 등록</span>
  </nav>

  <% if (flashError   != null) { %><div class="alert alert-error"  ><%= flashError   %></div><% } %>
  <% if (flashSuccess != null) { %><div class="alert alert-success"><%= flashSuccess %></div><% } %>

  <div class="admin-card">
    <h1 class="admin-title">상품 등록</h1>

    <form id="registForm" action="<%= ctx %>/admin/hat/regist" method="post"
          onsubmit="return validateRegist(this)">

      <div class="form-group">
        <label>상품명 <span style="color:var(--red)">*</span></label>
        <input type="text" name="hatName" class="form-control"
               placeholder="예: 클래식 볼캡 블랙" maxlength="100" autofocus>
      </div>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:0 20px;">
        <div class="form-group">
          <label>카테고리 <span style="color:var(--red)">*</span></label>
          <select name="hatCategory" class="form-control">
            <option value="">선택하세요</option>
            <option value="볼캡">볼캡</option>
            <option value="버킷햇">버킷햇</option>
            <option value="베레모">베레모</option>
            <option value="페도라">페도라</option>
            <option value="스냅백">스냅백</option>
          </select>
        </div>
        <div class="form-group">
          <label>가격 (원) <span style="color:var(--red)">*</span></label>
          <input type="number" name="hatPrice" class="form-control" placeholder="예: 29000" min="0" step="100">
        </div>
      </div>

      <div class="form-group">
        <label>재고 수량 <span style="color:var(--red)">*</span></label>
        <input type="number" name="hatStock" class="form-control" placeholder="예: 50" min="0" value="0" style="max-width:180px;">
      </div>

      <div class="form-group">
        <label>이미지 URL</label>
        <input type="text" name="hatImageUrl" id="hatImageUrl" class="form-control"
               placeholder="https://images.unsplash.com/photo-..."
               oninput="previewUrl(this.value)">
        <div id="previewWrap" class="img-preview-empty" style="margin-top:8px;">미리보기</div>
      </div>

      <div class="form-group">
        <label>상품 설명</label>
        <textarea name="hatDesc" class="form-control" rows="4"
                  placeholder="소재, 사이즈, 특징 등을 입력하세요." style="resize:vertical"></textarea>
      </div>

      <div class="admin-actions">
        <button type="submit" class="btn btn-primary">등록하기</button>
        <a href="<%= ctx %>/admin/hatList.jsp" class="btn btn-secondary">취소</a>
      </div>
    </form>
  </div>

</div>
</div>
</main>

<script>
function previewUrl(url) {
  var wrap = document.getElementById('previewWrap');
  if (!url || !url.startsWith('http')) {
    wrap.innerHTML = '미리보기';
    wrap.className = 'img-preview-empty';
    return;
  }
  wrap.innerHTML = '<img src="' + url.replace(/"/g,'') + '" class="img-preview" onerror="this.parentNode.innerHTML=\'URL을 확인하세요\';this.parentNode.className=\'img-preview-empty\'">';
  wrap.className = '';
  wrap.style = '';
}

function validateRegist(form) {
  if (!form.hatName.value.trim()) { alert('상품명을 입력하세요.'); form.hatName.focus(); return false; }
  if (!form.hatCategory.value)    { alert('카테고리를 선택하세요.'); form.hatCategory.focus(); return false; }
  var price = parseInt(form.hatPrice.value);
  if (isNaN(price) || price <= 0) { alert('가격을 올바르게 입력하세요.'); form.hatPrice.focus(); return false; }
  return true;
}
</script>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
