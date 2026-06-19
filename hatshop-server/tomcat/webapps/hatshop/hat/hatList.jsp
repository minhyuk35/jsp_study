<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.hat.HatDTO, com.hatshop.util.HtmlUtils, java.util.List, java.net.URLEncoder" %>
<%
    @SuppressWarnings("unchecked")
    List<HatDTO> hatList = (List<HatDTO>) request.getAttribute("hatList");
    int totalCount = (Integer) request.getAttribute("totalCount");
    int totalPages = (Integer) request.getAttribute("totalPages");
    int currentPage = (Integer) request.getAttribute("currentPage");
    String category = (String) request.getAttribute("category");
    String keyword = (String) request.getAttribute("keyword");
    String ctx = request.getContextPath();

    String encCat = URLEncoder.encode(category, "UTF-8");
    String encKwd = URLEncoder.encode(keyword, "UTF-8");
    String baseUrl = ctx + "/hat/list?category=" + encCat + "&keyword=" + encKwd;

    int pageBlock = 5;
    int startPage = Math.max(1, currentPage - (pageBlock / 2));
    int endPage = Math.min(totalPages, startPage + pageBlock - 1);
    if (endPage - startPage < pageBlock - 1) {
        startPage = Math.max(1, endPage - pageBlock + 1);
    }

    String[] cats = {"", "볼캡", "버킷햇", "베레모", "페도라", "스냅백"};
    String[] catLabels = {"전체", "볼캡", "버킷햇", "베레모", "페도라", "스냅백"};
    String noImage = ctx + "/images/no-image.png";
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<%@ include file="/WEB-INF/inc/nav.jsp" %>

<main class="main-content">
  <div class="container">
    <div class="list-header">
      <h1 class="page-title">모자 목록 <small>총 <%= totalCount %>개</small></h1>

      <div class="category-tabs">
        <% for (int ci = 0; ci < cats.length; ci++) {
             boolean isActive = cats[ci].equals(category);
             String tabUrl = ctx + "/hat/list?category="
                           + URLEncoder.encode(cats[ci], "UTF-8")
                           + "&page=1&keyword=" + encKwd;
        %>
        <a href="<%= tabUrl %>" class="category-tab <%= isActive ? "active" : "" %>"><%= catLabels[ci] %></a>
        <% } %>
      </div>

      <form class="search-bar" action="<%= ctx %>/hat/list" method="get" id="searchForm" autocomplete="off">
        <input type="hidden" name="category" value="<%= HtmlUtils.escape(category) %>">
        <div class="ac-wrap" style="flex:1;max-width:300px">
          <input type="text" name="keyword" id="searchInput" class="form-control"
                 value="<%= HtmlUtils.escape(keyword) %>" placeholder="상품명으로 검색...">
          <div class="ac-dropdown" id="acDropdown"></div>
        </div>
        <button type="submit" class="btn btn-primary">검색</button>
        <% if (!keyword.isEmpty()) { %>
        <a href="<%= ctx %>/hat/list?category=<%= encCat %>&page=1" class="btn btn-secondary">초기화</a>
        <% } %>
      </form>

      <% if (!keyword.isEmpty()) { %>
      <div style="margin-bottom:16px">
        <span class="keyword-tag">
          <svg class="icon-svg" style="width:.9em;height:.9em" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg> "<%= HtmlUtils.escape(keyword) %>"
          <a href="<%= ctx %>/hat/list?category=<%= encCat %>&page=1" title="검색 해제">✕</a>
        </span>
      </div>
      <% } %>

      <div class="result-bar">
        <span class="result-count">
          <strong><%= totalCount %></strong>개
          <% if (!category.isEmpty()) { %> · <b><%= HtmlUtils.escape(category) %></b><% } %>
        </span>
        <span><%= currentPage %> / <%= totalPages %> 페이지</span>
      </div>
    </div>

    <div class="hat-grid">
      <% if (hatList == null || hatList.isEmpty()) { %>
      <div class="empty-state">
        <div class="icon"><svg class="icon-svg" style="width:1em;height:1em" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg></div>
        <p>
          <% if (!keyword.isEmpty()) { %>
            "<%= HtmlUtils.escape(keyword) %>"에 대한 검색 결과가 없습니다.
          <% } else { %>
            등록된 상품이 없습니다.
          <% } %>
        </p>
        <a href="<%= ctx %>/hat/list" class="btn btn-outline">전체 목록 보기</a>
      </div>
      <% } else {
           for (HatDTO hat : hatList) {
             boolean soldOut = hat.isSoldOut();
             String imgSrc = hat.getHatImage();
             if (imgSrc == null || imgSrc.trim().isEmpty()) {
                 imgSrc = noImage;
             }
      %>
      <article class="hat-card">
        <a href="<%= ctx %>/hat/detail?hatNo=<%= hat.getHatNo() %>">
          <div class="hat-img-wrap">
            <% if (soldOut) { %>
            <div class="sold-out-overlay"><span class="sold-out-badge">품절</span></div>
            <% } %>
                <img src="<%= ctx %>/image?src=<%= URLEncoder.encode(imgSrc, "UTF-8") %>"
                 alt="<%= HtmlUtils.escape(hat.getHatName()) %>"
                 onerror="this.onerror=null;this.src='<%= noImage %>'">
          </div>
          <div class="hat-card-body">
            <span class="hat-cat-badge"><%= HtmlUtils.escape(hat.getHatCategory()) %></span>
            <p class="hat-card-name"><%= HtmlUtils.escape(hat.getHatName()) %></p>
            <p class="hat-card-price"><%= hat.getFormattedPrice() %>원</p>
            <% if (!soldOut && hat.getHatStock() <= 5) { %>
            <p class="low-stock-msg"><svg class="icon-svg" style="width:.85em;height:.85em" viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg> 잔여 <%= hat.getHatStock() %>개</p>
            <% } %>
          </div>
        </a>
      </article>
      <%   }
         }
      %>
    </div>

    <% if (totalPages > 1) { %>
    <nav class="pagination" aria-label="페이지 네비게이션">
      <% if (currentPage > 1) { %>
      <a href="<%= baseUrl %>&page=<%= currentPage - 1 %>" title="이전 페이지">‹</a>
      <% } else { %>
      <span style="opacity:.3;cursor:default">‹</span>
      <% } %>

      <% if (startPage > 1) { %>
      <a href="<%= baseUrl %>&page=1">1</a>
      <% if (startPage > 2) { %><span style="border:none;background:none;color:var(--text-muted)">…</span><% } %>
      <% } %>

      <% for (int p = startPage; p <= endPage; p++) { %>
      <a href="<%= baseUrl %>&page=<%= p %>" class="<%= p == currentPage ? "active" : "" %>"><%= p %></a>
      <% } %>

      <% if (endPage < totalPages) { %>
      <% if (endPage < totalPages - 1) { %><span style="border:none;background:none;color:var(--text-muted)">…</span><% } %>
      <a href="<%= baseUrl %>&page=<%= totalPages %>"><%= totalPages %></a>
      <% } %>

      <% if (currentPage < totalPages) { %>
      <a href="<%= baseUrl %>&page=<%= currentPage + 1 %>" title="다음 페이지">›</a>
      <% } else { %>
      <span style="opacity:.3;cursor:default">›</span>
      <% } %>
    </nav>
    <% } %>
  </div>
</main>

<script>
(function () {
  var input = document.getElementById('searchInput');
  var dropdown = document.getElementById('acDropdown');
  var form = document.getElementById('searchForm');
  if (!input || !dropdown) return;

  var ctx = '<%= ctx %>';
  var timer = null;
  var items = [];
  var activeIdx = -1;

  function closeDropdown() {
    dropdown.classList.remove('open');
    dropdown.innerHTML = '';
    items = [];
    activeIdx = -1;
  }

  function selectItem(item) {
    if (item.type === 'category') {
      window.location.href = ctx + '/hat/list?category=' + encodeURIComponent(item.text) + '&page=1';
    } else {
      input.value = item.text;
      closeDropdown();
      form.submit();
    }
  }

  function renderDropdown(data) {
    items = data.suggestions || [];
    if (items.length === 0) { closeDropdown(); return; }
    dropdown.innerHTML = '';
    items.forEach(function (item, idx) {
      var row = document.createElement('div');
      row.className = 'ac-item';
      var tag = document.createElement('span');
      tag.className = 'ac-tag';
      tag.textContent = item.type === 'category' ? '카테고리' : '상품';
      var label = document.createElement('span');
      label.textContent = item.text;
      row.appendChild(tag);
      row.appendChild(label);
      if (item.corrected) {
        var hint = document.createElement('span');
        hint.className = 'ac-corrected';
        hint.textContent = '(이 검색어를 찾으셨나요?)';
        row.appendChild(hint);
      }
      row.addEventListener('mousedown', function (e) { e.preventDefault(); selectItem(item); });
      dropdown.appendChild(row);
    });
    activeIdx = -1;
    dropdown.classList.add('open');
  }

  input.addEventListener('input', function () {
    var q = input.value.trim();
    clearTimeout(timer);
    if (!q) { closeDropdown(); return; }
    timer = setTimeout(function () {
      fetch(ctx + '/hat/suggest.jsp?q=' + encodeURIComponent(q))
        .then(function (res) { return res.ok ? res.json() : { suggestions: [] }; })
        .then(renderDropdown)
        .catch(function () { closeDropdown(); });
    }, 200);
  });

  input.addEventListener('keydown', function (e) {
    if (!dropdown.classList.contains('open')) return;
    var rows = dropdown.querySelectorAll('.ac-item');
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      activeIdx = Math.min(activeIdx + 1, rows.length - 1);
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      activeIdx = Math.max(activeIdx - 1, 0);
    } else if (e.key === 'Enter') {
      if (activeIdx >= 0 && items[activeIdx]) {
        e.preventDefault();
        selectItem(items[activeIdx]);
      }
      return;
    } else if (e.key === 'Escape') {
      closeDropdown();
      return;
    } else {
      return;
    }
    rows.forEach(function (r, i) { r.classList.toggle('active', i === activeIdx); });
  });

  document.addEventListener('click', function (e) {
    if (!dropdown.contains(e.target) && e.target !== input) closeDropdown();
  });
})();
</script>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
