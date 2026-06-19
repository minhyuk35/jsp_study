/*!
 * HatShop Client-side Validation v2
 *
 * 전역 함수 (하위 호환):
 *   validateJoin(form), validateLogin(form),
 *   checkIdAvailability(inputId, msgId, flagSetter),
 *   calcPwStrength(pw), validateCartQty(input), confirmDelete(msg)
 *
 * 네임스페이스 API:
 *   HatShop.validateId(id)        - 영문+숫자 5~20자
 *   HatShop.validatePw(pw)        - 8자+특수문자
 *   HatShop.validateEmail(email)  - 이메일 형식
 *   HatShop.validatePhone(phone)  - 010-0000-0000
 *   HatShop.showError(field, msg) - 인라인 에러 표시
 *   HatShop.clearError(field)     - 에러 제거
 *   HatShop.validateJoinForm()    - 회원가입 폼 전체 검사 (#joinForm)
 *   HatShop.autoFormatPhone(input)- 전화번호 자동 하이픈
 *   HatShop.setupRealtime(formId) - 실시간 유효성 리스너 등록
 */
(function (win, doc) {
    'use strict';

    /* ─────────────────────────────────────────────
       스타일 주입
    ───────────────────────────────────────────── */
    (function injectStyles() {
        if (doc.getElementById('hs-val-styles')) return;
        const s = doc.createElement('style');
        s.id = 'hs-val-styles';
        s.textContent =
            '.is-invalid{border-color:var(--danger,#e05252)!important;' +
            'box-shadow:0 0 0 3px rgba(224,82,82,.18)!important}' +
            '.is-valid{border-color:var(--success,#52c07a)!important}' +
            '.field-error{color:var(--danger,#e05252);font-size:.78rem;' +
            'margin-top:5px;display:block;animation:hsErrIn .15s ease}' +
            '.field-msg{font-size:.78rem;margin-top:5px}' +
            '.field-msg.ok{color:var(--success,#52c07a)}' +
            '.field-msg.err{color:var(--danger,#e05252)}' +
            '@keyframes hsErrIn{from{opacity:0;transform:translateY(-4px)}to{opacity:1;transform:none}}';
        doc.head.appendChild(s);
    })();

    /* ─────────────────────────────────────────────
       정규식 상수
    ───────────────────────────────────────────── */
    const ID_RE    = /^[a-zA-Z0-9]{5,20}$/;   // 아이디: 영문+숫자 5~20자
    const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;
    const PHONE_RE = /^010-\d{4}-\d{4}$/;

    /* ═══════════════════════════════════════════
       ① 핵심 검증 함수 (HatShop 네임스페이스)
    ═══════════════════════════════════════════ */

    /** 아이디: 영문+숫자 5~20자 */
    function validateId(id) {
        return typeof id === 'string' && ID_RE.test(id.trim());
    }

    /** 비밀번호: 8자 이상 + 특수문자 1개 이상 */
    function validatePw(pw) {
        if (!pw || pw.length < 8) return false;
        return /[!@#$%^&*()\-_=+\[\]{}|;':",.<>?/\\]/.test(pw);
    }

    /** 이메일 형식 */
    function validateEmail(email) {
        return typeof email === 'string' && EMAIL_RE.test(email.trim());
    }

    /** 전화번호: 010-0000-0000 */
    function validatePhone(phone) {
        return typeof phone === 'string' && PHONE_RE.test(phone.trim());
    }

    /* ═══════════════════════════════════════════
       ② DOM 에러 표시 / 제거 헬퍼
    ═══════════════════════════════════════════ */

    function getEl(field) {
        return typeof field === 'string' ? doc.querySelector(field) : field;
    }

    /** 필드 바로 아래에 .field-error 삽입 */
    function showError(field, msg) {
        const el = getEl(field);
        if (!el) return;
        el.classList.add('is-invalid');
        el.classList.remove('is-valid');

        const next = el.nextElementSibling;
        if (next && next.classList.contains('field-error')) next.remove();

        const errEl = doc.createElement('span');
        errEl.className = 'field-error';
        errEl.textContent = msg;
        el.parentNode.insertBefore(errEl, el.nextSibling);
    }

    /** 에러 제거 */
    function clearError(field) {
        const el = getEl(field);
        if (!el) return;
        el.classList.remove('is-invalid', 'is-valid');
        const next = el.nextElementSibling;
        if (next && next.classList.contains('field-error')) next.remove();
    }

    /** 유효 표시 (초록 테두리) */
    function setValid(field) {
        const el = getEl(field);
        if (!el) return;
        el.classList.remove('is-invalid');
        el.classList.add('is-valid');
        const next = el.nextElementSibling;
        if (next && next.classList.contains('field-error')) next.remove();
    }

    /** 폼 내 모든 인라인 에러 초기화 */
    function clearAllErrors(form) {
        if (!form) return;
        form.querySelectorAll('.is-invalid, .is-valid').forEach(el =>
            el.classList.remove('is-invalid', 'is-valid'));
        form.querySelectorAll('.field-error').forEach(el => el.remove());
    }

    /* ═══════════════════════════════════════════
       ③ 회원가입 폼 전체 검사
          대상: <form id="joinForm">
    ═══════════════════════════════════════════ */
    function validateJoinForm() {
        const form = doc.getElementById('joinForm');
        if (!form) { console.warn('[HatShop] #joinForm 없음'); return false; }
        clearAllErrors(form);

        let valid = true;

        // 아이디
        const idEl = form.querySelector('[name="memberId"]');
        if (idEl) {
            if (!idEl.value.trim()) {
                showError(idEl, '아이디를 입력하세요.'); valid = false;
            } else if (!validateId(idEl.value)) {
                showError(idEl, '아이디는 영문·숫자 5~20자여야 합니다.'); valid = false;
            } else if (idEl.dataset.idAvailable !== 'true') {
                // AJAX 중복 확인 후 idEl.dataset.idAvailable = 'true' 세팅 필요
                showError(idEl, '아이디 중복 확인을 완료해주세요.'); valid = false;
            } else {
                setValid(idEl);
            }
        }

        // 비밀번호
        const pwEl = form.querySelector('[name="memberPw"]');
        if (pwEl) {
            if (!pwEl.value) {
                showError(pwEl, '비밀번호를 입력하세요.'); valid = false;
            } else if (!validatePw(pwEl.value)) {
                showError(pwEl, '비밀번호는 8자 이상이며 특수문자를 포함해야 합니다.'); valid = false;
            } else {
                setValid(pwEl);
            }
        }

        // 비밀번호 확인
        const pwCEl = form.querySelector('[name="memberPwConfirm"]');
        if (pwCEl && pwEl) {
            if (!pwCEl.value) {
                showError(pwCEl, '비밀번호 확인을 입력하세요.'); valid = false;
            } else if (pwEl.value !== pwCEl.value) {
                showError(pwCEl, '비밀번호가 일치하지 않습니다.'); valid = false;
            } else {
                setValid(pwCEl);
            }
        }

        // 이름
        const nameEl = form.querySelector('[name="memberName"]');
        if (nameEl) {
            if (!nameEl.value.trim()) {
                showError(nameEl, '이름을 입력하세요.'); valid = false;
            } else { setValid(nameEl); }
        }

        // 이메일
        const emailEl = form.querySelector('[name="email"]');
        if (emailEl) {
            if (!emailEl.value.trim()) {
                showError(emailEl, '이메일을 입력하세요.'); valid = false;
            } else if (!validateEmail(emailEl.value)) {
                showError(emailEl, '올바른 이메일 형식이 아닙니다.'); valid = false;
            } else { setValid(emailEl); }
        }

        // 전화번호 (선택 — 값 있을 때만 형식 체크)
        const phoneEl = form.querySelector('[name="phone"]');
        if (phoneEl && phoneEl.value.trim()) {
            if (!validatePhone(phoneEl.value)) {
                showError(phoneEl, '전화번호 형식: 010-0000-0000'); valid = false;
            } else { setValid(phoneEl); }
        }

        if (!valid) {
            const first = form.querySelector('.is-invalid');
            if (first) first.focus();
        }
        return valid;
    }

    /* ═══════════════════════════════════════════
       ④ 전화번호 자동 하이픈
          사용: <input oninput="HatShop.autoFormatPhone(this)">
    ═══════════════════════════════════════════ */
    function autoFormatPhone(input) {
        let v = input.value.replace(/\D/g, '');
        if (v.length > 11) v = v.slice(0, 11);
        if      (v.length > 7) v = v.slice(0, 3) + '-' + v.slice(3, 7) + '-' + v.slice(7);
        else if (v.length > 3) v = v.slice(0, 3) + '-' + v.slice(3);
        input.value = v;
    }

    /* ═══════════════════════════════════════════
       ⑤ 실시간 유효성 셋업
          사용: HatShop.setupRealtime('joinForm')
    ═══════════════════════════════════════════ */
    function setupRealtime(formId) {
        const form = typeof formId === 'string' ? doc.getElementById(formId) : formId;
        if (!form) return;

        function wire(el, validator, errMsg) {
            if (!el) return;
            el.addEventListener('blur', function () {
                if (!this.value.trim()) return clearError(this);
                if (!validator(this.value)) showError(this, errMsg);
                else setValid(this);
            });
            el.addEventListener('input', function () {
                if (this.classList.contains('is-invalid') && validator(this.value))
                    setValid(this);
            });
        }

        wire(form.querySelector('[name="memberId"]'),  validateId,    '아이디는 영문·숫자 5~20자여야 합니다.');
        wire(form.querySelector('[name="email"]'),     validateEmail, '올바른 이메일 형식이 아닙니다.');
        wire(form.querySelector('[name="phone"]'),     validatePhone, '전화번호 형식: 010-0000-0000');

        const pwEl = form.querySelector('[name="memberPw"]');
        if (pwEl) {
            pwEl.addEventListener('blur', function () {
                if (!this.value) return clearError(this);
                if (!validatePw(this.value))
                    showError(this, '비밀번호는 8자 이상이며 특수문자를 포함해야 합니다.');
                else setValid(this);
            });
        }

        const pwCEl = form.querySelector('[name="memberPwConfirm"]');
        if (pwCEl && pwEl) {
            pwCEl.addEventListener('input', function () {
                if (!this.value) return clearError(this);
                if (pwEl.value !== this.value)
                    showError(this, '비밀번호가 일치하지 않습니다.');
                else setValid(this);
            });
        }

        const phoneEl = form.querySelector('[name="phone"]');
        if (phoneEl) phoneEl.addEventListener('input', function () { autoFormatPhone(this); });
    }

    /* ═══════════════════════════════════════════
       ⑥ 하위 호환 전역 함수 (기존 JSP에서 사용 중)
    ═══════════════════════════════════════════ */

    /* 기존 회원가입 폼 검사 (alert 방식, 하위 호환) */
    win.validateJoin = function (form) {
        if (!ID_RE.test(form.memberId.value.trim())) {
            alert('아이디는 5~20자 영문·숫자로 입력하세요.'); form.memberId.focus(); return false;
        }
        if (!validatePw(form.memberPw.value)) {
            alert('비밀번호는 8자 이상이며 특수문자를 포함해야 합니다.'); form.memberPw.focus(); return false;
        }
        const pw2Field = form.memberPw2 || form.memberPwConfirm;
        if (pw2Field && form.memberPw.value !== pw2Field.value) {
            alert('비밀번호가 일치하지 않습니다.'); pw2Field.focus(); return false;
        }
        if (!form.memberName.value.trim()) {
            alert('이름을 입력하세요.'); form.memberName.focus(); return false;
        }
        if (!EMAIL_RE.test(form.email.value.trim())) {
            alert('이메일 형식이 올바르지 않습니다.'); form.email.focus(); return false;
        }
        return true;
    };

    /* 로그인 폼 검사 */
    win.validateLogin = function (form) {
        if (!form.memberId.value.trim()) {
            alert('아이디를 입력하세요.'); form.memberId.focus(); return false;
        }
        if (!form.memberPw.value) {
            alert('비밀번호를 입력하세요.'); form.memberPw.focus(); return false;
        }
        return true;
    };

    /* AJAX 아이디 중복 확인 */
    win.checkIdAvailability = function (inputId, msgId, flagSetter) {
        const id  = doc.getElementById(inputId).value.trim();
        const msg = doc.getElementById(msgId);
        if (!id) { setFieldMsg(msg, '아이디를 입력하세요.', false); return; }
        if (!ID_RE.test(id)) { setFieldMsg(msg, '5~20자 영문·숫자만 입력하세요.', false); if (flagSetter) flagSetter(false); return; }

        const url = (typeof win.CTX !== 'undefined' ? win.CTX : '') + '/member/idCheck.jsp?memberId=' + encodeURIComponent(id);
        fetch(url)
            .then(r => r.json())
            .then(data => {
                setFieldMsg(msg, data.message, data.available);
                const idInput = doc.getElementById(inputId);
                if (idInput) idInput.dataset.idAvailable = data.available ? 'true' : 'false';
                if (flagSetter) flagSetter(data.available);
            })
            .catch(() => setFieldMsg(msg, '서버 오류가 발생했습니다.', false));
    };

    /* 비밀번호 강도 0~4 */
    win.calcPwStrength = function (pw) {
        let s = 0;
        if (pw.length >= 8)          s++;
        if (/[A-Z]/.test(pw))        s++;
        if (/[0-9]/.test(pw))        s++;
        if (/[^A-Za-z0-9]/.test(pw)) s++;
        return s;
    };

    /* 장바구니 수량 범위 보정 */
    win.validateCartQty = function (input) {
        const v = parseInt(input.value);
        if (isNaN(v) || v < 1) input.value = 1;
        else if (v > 99)       input.value = 99;
    };

    /* 삭제 확인 다이얼로그 */
    win.confirmDelete = function (msg) {
        return confirm(msg || '정말 삭제하시겠습니까?');
    };

    /* 내부 유틸 */
    function setFieldMsg(el, text, isOk) {
        if (!el) return;
        el.textContent = text;
        el.className   = 'field-msg ' + (isOk ? 'ok' : 'err');
    }

    /* ═══════════════════════════════════════════
       Public API 노출
    ═══════════════════════════════════════════ */
    win.HatShop = win.HatShop || {};
    Object.assign(win.HatShop, {
        validateId,
        validatePw,
        validateEmail,
        validatePhone,
        showError,
        clearError,
        setValid,
        clearAllErrors,
        validateJoinForm,
        autoFormatPhone,
        setupRealtime
    });

})(window, document);
