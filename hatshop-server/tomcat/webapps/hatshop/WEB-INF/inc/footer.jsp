<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="site-footer">

    <div class="footer__top">
        <div class="footer__brand">
            <a href="${pageContext.request.contextPath}/" class="logo">HATSHOP</a>
            <p>모자 그 이상의 태도. 절제된 디자인으로<br>매일의 룩을 완성하는 헤드웨어.</p>
            <form class="footer__news" onsubmit="return false;">
                <input type="email" placeholder="이메일로 신상품 소식 받기" aria-label="이메일">
                <button type="submit">→</button>
            </form>
        </div>

        <div class="footer__col">
            <h4>쇼핑</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/hat/list?category=%EB%B3%BC%EC%BA%A1">볼캡</a></li>
                <li><a href="${pageContext.request.contextPath}/hat/list?category=%EB%B2%84%ED%82%B7%ED%96%87">버킷햇</a></li>
                <li><a href="${pageContext.request.contextPath}/hat/list?category=%EB%B2%A0%EB%A0%88%EB%AA%A8">베레모</a></li>
                <li><a href="${pageContext.request.contextPath}/hat/list?category=%ED%8E%98%EB%8F%84%EB%9D%BC">페도라</a></li>
                <li><a href="${pageContext.request.contextPath}/hat/list?category=%EC%8A%A4%EB%83%85%EB%B0%B1">스냅백</a></li>
                <li><a href="${pageContext.request.contextPath}/hat/list">전체 목록</a></li>
            </ul>
        </div>

        <div class="footer__col">
            <h4>회원</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/member/login.jsp">로그인</a></li>
                <li><a href="${pageContext.request.contextPath}/member/join.jsp">회원가입</a></li>
                <li><a href="${pageContext.request.contextPath}/member/mypage.jsp">마이페이지</a></li>
                <li><a href="${pageContext.request.contextPath}/cart/cartList.jsp">장바구니</a></li>
                <li><a href="${pageContext.request.contextPath}/order/orderList.jsp">주문내역</a></li>
            </ul>
        </div>

        <div class="footer__col">
            <h4>고객센터</h4>
            <ul>
                <li><a href="${pageContext.request.contextPath}/info/delivery.jsp">배송 안내</a></li>
                <li><a href="${pageContext.request.contextPath}/info/returns.jsp">교환 / 반품</a></li>
                <li><a href="${pageContext.request.contextPath}/info/size-guide.jsp">사이즈 가이드</a></li>
                <li><a href="${pageContext.request.contextPath}/board/boardList.jsp">커뮤니티</a></li>
            </ul>
        </div>
    </div>

    <div class="footer__bottom">
        <small>© 2026 HATSHOP. All rights reserved.</small>
        <div class="legal">
            <a href="#">이용약관</a>
            <a href="#">개인정보처리방침</a>
        </div>
    </div>

</footer>

<!-- ── AI 고객 상담 챗봇 위젯 ── -->
<div id="hsChatbot" class="hs-chatbot">
  <button id="hsChatToggle" type="button" class="hs-chat-toggle" aria-label="고객 상담 챗봇 열기">💬</button>
  <div id="hsChatPanel" class="hs-chat-panel" hidden>
    <div class="hs-chat-header">
      <span>HATSHOP 고객 상담</span>
      <button id="hsChatClose" type="button" class="hs-chat-close" aria-label="닫기">✕</button>
    </div>
    <div id="hsChatBody" class="hs-chat-body"></div>
    <div id="hsChatQuick" class="hs-chat-quick"></div>
    <div class="ac-wrap" style="margin:0 12px">
      <div id="hsAcDropdown" class="ac-dropdown"></div>
    </div>
    <form id="hsChatForm" class="hs-chat-form">
      <input type="text" id="hsChatInput" placeholder="질문을 입력하세요..." autocomplete="off">
      <button type="submit">전송</button>
    </form>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script>window.HS_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/js/chatbot.js"></script>
</body>
</html>
