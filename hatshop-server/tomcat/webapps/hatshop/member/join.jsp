<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO" %>
<%
    /* 이미 로그인된 사용자는 메인으로 */
    if (session.getAttribute("loginUser") != null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
    String flashError = (String) session.getAttribute("joinError");
    session.removeAttribute("joinError");
    String prefill = (String) session.getAttribute("joinPrefill");
    session.removeAttribute("joinPrefill");
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<%@ include file="/WEB-INF/inc/nav.jsp" %>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
.join-wrap { max-width: 560px; margin: 48px auto; }
.input-row  { display: flex; gap: 8px; }
.input-row .form-control { flex: 1; }
.field-msg  { font-size: .8rem; margin-top: 4px; display: block; min-height: 1em; }
.field-msg.ok  { color: var(--success); }
.field-msg.err { color: var(--danger); }
.pw-strength { height: 4px; border-radius: 2px; margin-top: 6px;
               background: var(--border); overflow: hidden; }
.pw-strength-bar { height: 100%; border-radius: 2px; transition: width .3s, background .3s; width: 0; }
.required { color: var(--danger); margin-left: 2px; }
</style>

<main class="main-content">
<div class="container">
<div class="join-wrap">

  <h2 style="text-align:center;margin-bottom:8px">회원가입</h2>
  <p style="text-align:center;color:var(--text-secondary);font-size:.9rem;margin-bottom:28px">
    HatShop과 함께 모자 쇼핑을 시작하세요
  </p>

  <% if (flashError != null) { %>
  <div class="alert alert-error"><%= flashError %></div>
  <% } %>

  <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:12px;padding:32px">
    <form id="joinForm" action="<%= request.getContextPath() %>/member/joinProc.jsp" method="post"
          onsubmit="return validateJoinForm(this)">

      <!-- 아이디 -->
      <div class="form-group">
        <label for="memberId">아이디 <span class="required">*</span></label>
        <div class="input-row">
          <input type="text" id="memberId" name="memberId" class="form-control"
                 placeholder="4~20자 영문·숫자" maxlength="20" autocomplete="username"
                 value="<%= prefill != null ? prefill : "" %>"
                 oninput="resetIdCheck()">
          <button type="button" class="btn btn-secondary btn-sm"
                  style="white-space:nowrap" onclick="checkIdAvail()">중복 확인</button>
        </div>
        <small id="idMsg" class="field-msg"></small>
      </div>

      <!-- 비밀번호 -->
      <div class="form-group">
        <label for="memberPw">비밀번호 <span class="required">*</span></label>
        <input type="password" id="memberPw" name="memberPw" class="form-control"
               placeholder="8자 이상, 영문+숫자" autocomplete="new-password"
               oninput="updatePwStrength(this.value)">
        <div class="pw-strength"><div id="pwStrengthBar" class="pw-strength-bar"></div></div>
        <small id="pwMsg" class="field-msg"></small>
      </div>

      <!-- 비밀번호 확인 -->
      <div class="form-group">
        <label for="memberPw2">비밀번호 확인 <span class="required">*</span></label>
        <input type="password" id="memberPw2" name="memberPw2" class="form-control"
               placeholder="비밀번호 재입력" autocomplete="new-password"
               oninput="checkPwMatch()">
        <small id="pw2Msg" class="field-msg"></small>
      </div>

      <!-- 이름 -->
      <div class="form-group">
        <label for="memberName">이름 <span class="required">*</span></label>
        <input type="text" id="memberName" name="memberName" class="form-control"
               placeholder="실명 입력" maxlength="30">
      </div>

      <!-- 이메일 -->
      <div class="form-group">
        <label for="email">이메일 <span class="required">*</span></label>
        <input type="email" id="email" name="email" class="form-control"
               placeholder="example@email.com" maxlength="100">
      </div>

      <!-- 전화번호 -->
      <div class="form-group">
        <label for="phone">전화번호</label>
        <input type="tel" id="phone" name="phone" class="form-control"
               placeholder="010-0000-0000" maxlength="20">
      </div>

      <!-- 주소 -->
      <div class="form-group">
        <label for="zonecode">우편번호 <span class="required">*</span></label>
        <div class="input-row">
          <input type="text" id="zonecode" class="form-control" style="max-width:130px"
                 placeholder="우편번호" readonly>
          <button type="button" class="btn btn-secondary btn-sm" style="white-space:nowrap" onclick="searchAddress()">주소 검색</button>
        </div>
      </div>
      <div class="form-group">
        <label for="roadAddr">기본주소 <span class="required">*</span></label>
        <input type="text" id="roadAddr" class="form-control" placeholder="주소 검색 버튼을 클릭하세요" readonly onclick="searchAddress()">
      </div>
      <div class="form-group">
        <label for="detailAddr">상세주소 <span class="required">*</span></label>
        <input type="text" id="detailAddr" class="form-control" placeholder="동/호수 등 상세주소를 입력하세요" maxlength="100">
      </div>
      <input type="hidden" id="addr" name="addr">

      <button type="submit" class="btn btn-primary" style="width:100%;margin-top:8px">
        가입하기
      </button>
    </form>
  </div>

  <p style="text-align:center;margin-top:16px;font-size:.9rem;color:var(--text-secondary)">
    이미 계정이 있으신가요?
    <a href="<%= request.getContextPath() %>/member/login.jsp"
       style="color:var(--accent)">로그인</a>
  </p>

</div>
</div>
</main>

<script>
const CTX = '<%= request.getContextPath() %>';
let idAvailable = false;

/* ── 아이디 중복 확인 (AJAX) ── */
function checkIdAvail() {
    const id = document.getElementById('memberId').value.trim();
    const msg = document.getElementById('idMsg');

    if (!id) { setMsg(msg, '아이디를 입력하세요.', false); return; }
    if (!/^[a-zA-Z0-9]{4,20}$/.test(id)) {
        setMsg(msg, '4~20자 영문·숫자만 입력하세요.', false);
        idAvailable = false; return;
    }

    fetch(CTX + '/member/idCheck.jsp?memberId=' + encodeURIComponent(id))
        .then(r => r.json())
        .then(data => {
            idAvailable = data.available;
            setMsg(msg, data.message, data.available);
        })
        .catch(() => setMsg(msg, '중복 확인 중 오류가 발생했습니다.', false));
}

function resetIdCheck() {
    idAvailable = false;
    const msg = document.getElementById('idMsg');
    msg.textContent = '';
    msg.className = 'field-msg';
}

/* ── 비밀번호 강도 ── */
function updatePwStrength(pw) {
    const bar = document.getElementById('pwStrengthBar');
    const msg = document.getElementById('pwMsg');
    let score = 0;
    if (pw.length >= 8)  score++;
    if (/[A-Z]/.test(pw)) score++;
    if (/[0-9]/.test(pw)) score++;
    if (/[^A-Za-z0-9]/.test(pw)) score++;

    const levels = [
        { w:'25%',  c:'#e05252', t:'' },
        { w:'50%',  c:'#e09852', t:'약함' },
        { w:'75%',  c:'#e5d44e', t:'보통' },
        { w:'100%', c:'#52c07a', t:'강함' }
    ];
    if (pw.length === 0) { bar.style.width='0'; msg.textContent=''; return; }
    const lv = levels[Math.min(score - 1, 3)] || levels[0];
    bar.style.width = lv.w;
    bar.style.background = lv.c;
    setMsg(msg, lv.t ? `비밀번호 강도: ${lv.t}` : '더 강한 비밀번호를 사용하세요.', score >= 2);
    checkPwMatch();
}

/* ── 비밀번호 일치 확인 ── */
function checkPwMatch() {
    const pw  = document.getElementById('memberPw').value;
    const pw2 = document.getElementById('memberPw2').value;
    const msg = document.getElementById('pw2Msg');
    if (!pw2) { msg.textContent=''; return; }
    if (pw === pw2) setMsg(msg, '비밀번호가 일치합니다.', true);
    else            setMsg(msg, '비밀번호가 일치하지 않습니다.', false);
}

/* ── 다음(카카오) 우편번호 검색 ── */
function searchAddress() {
    new daum.Postcode({
        oncomplete: function (data) {
            document.getElementById('zonecode').value = data.zonecode;
            document.getElementById('roadAddr').value = data.roadAddress || data.jibunAddress;
            document.getElementById('detailAddr').focus();
        }
    }).open();
}

/* ── 폼 최종 유효성 검사 ── */
function validateJoinForm(form) {
    const id   = form.memberId.value.trim();
    const pw   = form.memberPw.value;
    const pw2  = form.memberPw2.value;
    const name = form.memberName.value.trim();
    const email = form.email.value.trim();
    const zonecode   = document.getElementById('zonecode').value.trim();
    const roadAddr   = document.getElementById('roadAddr').value.trim();
    const detailAddr = document.getElementById('detailAddr').value.trim();

    if (!id || !/^[a-zA-Z0-9]{4,20}$/.test(id)) {
        alert('아이디는 4~20자 영문·숫자로 입력하세요.'); form.memberId.focus(); return false;
    }
    if (!idAvailable) {
        alert('아이디 중복 확인을 해주세요.'); form.memberId.focus(); return false;
    }
    if (pw.length < 8) {
        alert('비밀번호는 8자 이상 입력하세요.'); form.memberPw.focus(); return false;
    }
    if (pw !== pw2) {
        alert('비밀번호가 일치하지 않습니다.'); form.memberPw2.focus(); return false;
    }
    if (!name) {
        alert('이름을 입력하세요.'); form.memberName.focus(); return false;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        alert('이메일 형식이 올바르지 않습니다.'); form.email.focus(); return false;
    }
    if (!zonecode || !roadAddr) {
        alert('주소 검색을 통해 주소를 입력해주세요.'); searchAddress(); return false;
    }
    if (!detailAddr) {
        alert('상세주소를 입력해주세요.'); document.getElementById('detailAddr').focus(); return false;
    }
    document.getElementById('addr').value = '[' + zonecode + '] ' + roadAddr + ' ' + detailAddr;
    return true;
}

/* ── 유틸 ── */
function setMsg(el, text, isOk) {
    el.textContent = text;
    el.className = 'field-msg ' + (isOk ? 'ok' : 'err');
}
</script>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
