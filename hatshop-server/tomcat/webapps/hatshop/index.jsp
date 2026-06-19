<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.hat.*,java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
    HatDAO _dao = new HatDAO();
  List<HatDTO> newArrivals = new ArrayList<>();
  List<HatDTO> bestSellers = new ArrayList<>();
  String[] mainCats = {"볼캡", "버킷햇", "베레모", "페도라", "스냅백"};
  try {
    for (String cat : mainCats) {
      newArrivals.addAll(_dao.getMainHatList(cat, 4));
      bestSellers.addAll(_dao.getMainHatList(cat, 4));
    }
  } catch (Exception e) {}
    String ctx = request.getContextPath();
  String noImage = ctx + "/images/no-image.png";
    String heroProxy = ctx + "/image?src=" + URLEncoder.encode("https://images.unsplash.com/photo-1521369909029-2afed882baee?w=900&q=85&fit=crop", "UTF-8");
    String capProxy = ctx + "/image?src=" + URLEncoder.encode("https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=900&q=80&fit=crop", "UTF-8");
    String bucketProxy = ctx + "/image?src=" + URLEncoder.encode("https://images.unsplash.com/photo-1556306535-0f09a537f0a3?w=700&q=80&fit=crop", "UTF-8");
    String beretProxy = ctx + "/image?src=" + URLEncoder.encode("https://images.unsplash.com/photo-1514848162001-6c196f60118b?w=700&q=80&fit=crop", "UTF-8");
    String fedoraProxy = ctx + "/image?src=" + URLEncoder.encode("https://images.unsplash.com/photo-1604871000636-074fa5117945?w=700&q=80&fit=crop", "UTF-8");
    String snapProxy = ctx + "/image?src=" + URLEncoder.encode("https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=700&q=80&fit=crop", "UTF-8");
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<main id="top">

<!-- ═══════════════════════════════════════════════════════
     HERO
═══════════════════════════════════════════════════════ -->
<section class="hero">
  <div class="hero__stage">

    <!-- headline base (outline, behind image) -->
    <h1 class="hero__head hero__head--base" aria-hidden="true">
      <span>Wear Your</span>
      <span>Statement.</span>
    </h1>

    <!-- hero hat image -->
    <div class="hero__hat">
      <img src="<%= heroProxy %>"
           alt="HATSHOP hero">
    </div>

    <!-- headline fill (solid, above image — masked to hat bounding box) -->
    <h1 class="hero__head hero__head--fill">
      <span>Wear Your</span>
      <span>Statement.</span>
    </h1>

  </div>

  <p class="hero__eyebrow">New Collection 2026</p>

  <div class="hero__foot">
    <p class="hero__sub">
      볼캡, 버킷햇, 베레모, 페도라, 스냅백.<br>
      당신의 태도를 완성하는 헤드웨어 200+.
    </p>
    <div class="hero__cta">
      <a href="<%= ctx %>/hat/list" class="btn">Shop Now <span class="arr">→</span></a>
      <a href="<%= ctx %>/hat/list?category=%EB%B2%84%ED%82%B7%ED%96%87" class="btn btn--outline">버킷햇 보기</a>
    </div>
  </div>

  <div class="hero__scroll"><span>scroll</span><i></i></div>
</section>


<!-- ═══════════════════════════════════════════════════════
     CATEGORY GRID
═══════════════════════════════════════════════════════ -->
<section class="categories wrap" id="categories">
  <div class="section-head">
    <div>
      <p class="eyebrow" style="margin-bottom:14px">Shop by category</p>
      <h2 class="section-title">Find Your<br>Silhouette</h2>
    </div>
    <a href="<%= ctx %>/hat/list" class="link-more">View all →</a>
  </div>

  <div class="cat-grid">

    <!-- 볼캡 (big card) -->
    <a href="<%= ctx %>/hat/list?category=%EB%B3%BC%EC%BA%A1" class="cat-card">
      <div class="media">
        <img src="<%= capProxy %>"
             alt="볼캡">
      </div>
      <div class="veil"></div>
      <div class="label">
        <small>01 — 40 styles</small>
        <strong>볼캡</strong>
        <span class="go">Explore →</span>
      </div>
    </a>

    <!-- 버킷햇 -->
    <a href="<%= ctx %>/hat/list?category=%EB%B2%84%ED%82%B7%ED%96%87" class="cat-card">
      <div class="media">
        <img src="<%= bucketProxy %>"
             alt="버킷햇">
      </div>
      <div class="veil"></div>
      <div class="label">
        <small>02 — 40 styles</small>
        <strong>버킷햇</strong>
        <span class="go">Explore →</span>
      </div>
    </a>

    <!-- 베레모 -->
    <a href="<%= ctx %>/hat/list?category=%EB%B2%A0%EB%A0%88%EB%AA%A8" class="cat-card">
      <div class="media">
        <img src="<%= beretProxy %>"
             alt="베레모">
      </div>
      <div class="veil"></div>
      <div class="label">
        <small>03 — 40 styles</small>
        <strong>베레모</strong>
        <span class="go">Explore →</span>
      </div>
    </a>

    <!-- 페도라 -->
    <a href="<%= ctx %>/hat/list?category=%ED%8E%98%EB%8F%84%EB%9D%BC" class="cat-card">
      <div class="media">
        <img src="<%= fedoraProxy %>"
             alt="페도라">
      </div>
      <div class="veil"></div>
      <div class="label">
        <small>04 — 40 styles</small>
        <strong>페도라</strong>
        <span class="go">Explore →</span>
      </div>
    </a>

    <!-- 스냅백 -->
    <a href="<%= ctx %>/hat/list?category=%EC%8A%A4%EB%83%85%EB%B0%B1" class="cat-card">
      <div class="media">
        <img src="<%= snapProxy %>"
             alt="스냅백">
      </div>
      <div class="veil"></div>
      <div class="label">
        <small>05 — 40 styles</small>
        <strong>스냅백</strong>
        <span class="go">Explore →</span>
      </div>
    </a>

  </div>
</section>


<!-- ═══════════════════════════════════════════════════════
     NEW ARRIVALS
═══════════════════════════════════════════════════════ -->
<section class="arrivals wrap" id="arrivals">
  <div class="section-head">
    <div>
      <p class="eyebrow" style="margin-bottom:14px">5 categories · 200 styles</p>
      <h2 class="section-title">Shop The<br>Lineup</h2>
    </div>
    <a href="<%= ctx %>/hat/list" class="link-more">View all →</a>
  </div>

  <% if (newArrivals.isEmpty()) { %>
  <div style="padding:80px 0;text-align:center;color:var(--ink-soft)">
    <p>등록된 상품이 없습니다.</p>
  </div>
  <% } else { %>
  <div class="product-grid">
    <% for (HatDTO hat : newArrivals) {
          String _src = hat.getHatImage();
          if (_src == null || _src.trim().isEmpty()) {
           _src = noImage;
          }
         boolean _sold = hat.isSoldOut();
    %>
    <article class="product">
      <a href="<%= ctx %>/hat/detail?hatNo=<%= hat.getHatNo() %>">
        <div class="product__media">
          <% if (_sold) { %><span class="product__tag sold">SOLD</span><% } else if (hat.getHatStock() <= 5) { %><span class="product__tag">잔여 <%= hat.getHatStock() %></span><% } %>
          <div class="media">
            <img src="<%= _src %>" alt="<%= hat.getHatName() %>"
              onerror="this.onerror=null;this.src='<%= noImage %>'">
          </div>
          <% if (!_sold) { %>
          <button class="quick-add" type="button"
                  onclick="event.preventDefault();location.href='<%= ctx %>/hat/detail?hatNo=<%= hat.getHatNo() %>'">
            자세히 보기 →
          </button>
          <% } %>
        </div>
        <p class="product__brand"><%= hat.getHatCategory() %></p>
        <h3 class="product__name"><%= hat.getHatName() %></h3>
        <div class="product__row">
          <span class="product__price"><%= hat.getFormattedPrice() %>원</span>
          <% if (!_sold) { %>
          <span class="product__add">+</span>
          <% } %>
        </div>
      </a>
    </article>
    <% } %>
  </div>
  <% } %>
</section>


<!-- ═══════════════════════════════════════════════════════
     TEXT BANNER
═══════════════════════════════════════════════════════ -->
<section class="text-banner" id="banner">
  <p class="eyebrow">Craft &amp; Form</p>
  <h2>
    <span>The Art Of</span>
    <span>The Hat.</span>
  </h2>
  <p>한 땀의 스티치부터 챙의 곡률까지.<br>
     볼캡부터 페도라까지 모든 스타일을 한 곳에서.</p>
  <a href="<%= ctx %>/hat/list" class="btn btn--invert">전체 보기 <span class="arr">→</span></a>
</section>


<!-- ═══════════════════════════════════════════════════════
     BEST SELLERS  (slider)
═══════════════════════════════════════════════════════ -->
<% if (!bestSellers.isEmpty()) { %>
<section class="bestsellers wrap" id="bestsellers">
  <div class="section-head">
    <div>
      <p class="eyebrow" style="margin-bottom:14px">Loved by many</p>
      <h2 class="section-title">Best Sellers</h2>
    </div>
    <div class="slider__nav">
      <button class="slider__btn" id="prevBtn" aria-label="이전">←</button>
      <button class="slider__btn" id="nextBtn" aria-label="다음">→</button>
    </div>
  </div>

  <div class="slider__track" id="bestTrack">
    <% int _rank = 1; for (HatDTO bh : bestSellers) {
       String _bs = bh.getHatImage();
       if (_bs == null || _bs.trim().isEmpty()) {
         _bs = noImage;
       }
    %>
    <article class="product slide">
      <a href="<%= ctx %>/hat/detail?hatNo=<%= bh.getHatNo() %>">
        <div class="product__media">
          <div class="media">
            <img src="<%= _bs %>" alt="<%= bh.getHatName() %>"
              onerror="this.onerror=null;this.src='<%= noImage %>'">
          </div>
          <span class="rank">0<%= _rank %></span>
        </div>
        <p class="product__brand"><%= bh.getHatCategory() %></p>
        <h3 class="product__name"><%= bh.getHatName() %></h3>
        <div class="product__row">
          <span class="product__price"><%= bh.getFormattedPrice() %>원</span>
        </div>
      </a>
    </article>
    <% _rank++; } %>
  </div>
</section>

<script>
(function(){
  var track = document.getElementById('bestTrack');
  var prev  = document.getElementById('prevBtn');
  var next  = document.getElementById('nextBtn');
  if (!track) return;
  function step(){
    var c = track.querySelector('.slide');
    return c ? c.getBoundingClientRect().width + 14 : 320;
  }
  function upd(){
    var max = track.scrollWidth - track.clientWidth - 2;
    if(prev) prev.disabled = track.scrollLeft <= 2;
    if(next) next.disabled = track.scrollLeft >= max;
  }
  if(prev) prev.addEventListener('click', function(){ track.scrollBy({left:-step()*1.2,behavior:'smooth'}); });
  if(next) next.addEventListener('click', function(){ track.scrollBy({left: step()*1.2,behavior:'smooth'}); });
  track.addEventListener('scroll', upd, {passive:true});
  window.addEventListener('resize', upd);
  upd();
})();
</script>
<% } %>


<!-- ═══════════════════════════════════════════════════════
     FEATURES
═══════════════════════════════════════════════════════ -->
<div class="feature-strip">
  <div class="container">
    <div class="features">
      <div class="feature-card">
        <div class="icon"><svg class="icon-svg" style="width:1.6em;height:1.6em" viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg></div>
        <h3>무료 배송</h3>
        <p>5만원 이상 구매 시<br>전국 무료 배송</p>
      </div>
      <div class="feature-card">
        <div class="icon"><svg class="icon-svg" style="width:1.6em;height:1.6em" viewBox="0 0 24 24"><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg></div>
        <h3>교환 · 반품</h3>
        <p>수령 후 7일 이내<br>무료 교환 / 반품</p>
      </div>
      <div class="feature-card">
        <div class="icon"><svg class="icon-svg" style="width:1.6em;height:1.6em" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></div>
        <h3>안전 결제</h3>
        <p>SSL 보안 인증<br>안전한 결제 환경</p>
      </div>
      <div class="feature-card">
        <div class="icon"><svg class="icon-svg" style="width:1.6em;height:1.6em" viewBox="0 0 24 24"><path d="M3 18v-6a9 9 0 0 1 18 0v6"/><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/></svg></div>
        <h3>고객 지원</h3>
        <p>평일 09:00–18:00<br>친절한 상담</p>
      </div>
    </div>
  </div>
</div>

</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
