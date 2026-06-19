(function () {
  'use strict';

  var CTX = window.HS_CTX || '';
  var els = {};
  var mode = 'menu';
  var faqQuestions = [
    '배송은 얼마나 걸리나요?',
    '교환·환불은 어떻게 하나요?',
    '사이즈는 어떻게 선택하나요?',
    '회원가입 혜택이 있나요?'
  ];
  var refundReasons = [
    { code: 'CHANGE_MIND',   label: '단순 변심' },
    { code: 'DEFECTIVE',     label: '상품 불량/하자' },
    { code: 'WRONG_ITEM',    label: '오배송' },
    { code: 'SIZE_COLOR',    label: '사이즈/색상 불일치' },
    { code: 'LATE_DELIVERY', label: '배송 지연' },
    { code: 'OTHER',         label: '기타' }
  ];
  var refundGuide = {
    CHANGE_MIND:   '단순 변심으로 인한 환불은 상품 수령 후 7일 이내, 미사용 상태일 때 가능합니다. 반품 배송비(편도 3,000원)는 고객 부담입니다.',
    DEFECTIVE:     '상품 불량·하자의 경우 배송비 부담 없이 환불이 가능합니다. 가능하다면 불량 부위 사진을 함께 준비해주시면 빠르게 처리됩니다.',
    WRONG_ITEM:    '오배송(다른 상품 수령)의 경우 배송비 부담 없이 환불 또는 교환이 가능합니다.',
    SIZE_COLOR:    '사이즈·색상이 주문과 다르게 온 경우 배송비 부담 없이 환불 또는 교환이 가능합니다.',
    LATE_DELIVERY: '배송이 지나치게 지연된 경우 환불 신청이 가능합니다. 정확한 처리를 위해 주문번호를 꼭 확인해주세요.',
    OTHER:         '기타 사유로도 환불 신청이 가능합니다. 마이페이지에서 해당 주문을 선택해 상세 사유를 입력해주세요.'
  };

  function $(html) {
    var t = document.createElement('template');
    t.innerHTML = html.trim();
    return t.content.firstElementChild;
  }

  function escapeHtml(s) {
    if (s == null) return '';
    return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
  }

  function scrollToBottom() {
    els.body.scrollTop = els.body.scrollHeight;
  }

  function addBotMsg(text) {
    var el = $('<div class="hs-msg bot"></div>');
    el.textContent = text;
    els.body.appendChild(el);
    scrollToBottom();
    return el;
  }

  function addUserMsg(text) {
    var el = $('<div class="hs-msg user"></div>');
    el.textContent = text;
    els.body.appendChild(el);
    scrollToBottom();
  }

  function addTyping() {
    var el = $('<div class="hs-msg bot typing">답변 작성 중...</div>');
    els.body.appendChild(el);
    scrollToBottom();
    return el;
  }

  function clearQuick() {
    els.quick.innerHTML = '';
  }

  function addQuickBtn(label, onClick) {
    var btn = $('<button type="button" class="hs-quick-btn"></button>');
    btn.textContent = label;
    btn.addEventListener('click', onClick);
    els.quick.appendChild(btn);
    return btn;
  }

  function fetchWithTimeout(url, options, timeoutMs) {
    var controller = ('AbortController' in window) ? new AbortController() : null;
    var opts = options || {};
    if (controller) opts.signal = controller.signal;
    var timer = controller ? setTimeout(function () { controller.abort(); }, timeoutMs || 15000) : null;
    return fetch(url, opts).finally(function () {
      if (timer) clearTimeout(timer);
    });
  }

  function askAI(message) {
    addUserMsg(message);
    var typingEl = addTyping();
    fetchWithTimeout(CTX + '/chat/ask.jsp', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
      body: 'message=' + encodeURIComponent(message)
    }, 20000).then(function (res) {
      if (!res.ok) throw new Error('HTTP ' + res.status);
      return res.json();
    }).then(function (data) {
      typingEl.remove();
      addBotMsg(data && data.reply ? data.reply : '죄송합니다, 답변을 가져오지 못했습니다.');
    }).catch(function (err) {
      typingEl.remove();
      addBotMsg('죄송합니다, 지금은 답변하기 어렵습니다. 잠시 후 다시 시도하거나 고객센터 문의를 이용해주세요.');
    });
  }

  function renderMenu() {
    mode = 'menu';
    closeAcDropdown();
    els.input.placeholder = '질문을 입력하세요...';
    clearQuick();
    faqQuestions.forEach(function (q) {
      addQuickBtn(q, function () { askAI(q); });
    });
    addQuickBtn('🔍 상품 찾기', renderSearchMode);
    addQuickBtn('↩️ 환불 신청 안내', renderRefundMode);
    addQuickBtn('🎧 고객센터 문의', renderInquiryMode);
  }

  function renderBackBtn() {
    addQuickBtn('« 메뉴로', function () {
      clearQuick();
      renderMenu();
    });
  }

  function renderSearchMode() {
    mode = 'search';
    addBotMsg('찾고 싶은 상품명을 입력해주세요. (예: 버킷햇, 베레모)');
    clearQuick();
    renderBackBtn();
    els.input.placeholder = '상품명을 입력하세요...';
  }

  function closeAcDropdown() {
    if (!els.acDropdown) return;
    els.acDropdown.classList.remove('open');
    els.acDropdown.innerHTML = '';
  }

  function renderAcDropdown(data) {
    var sugg = (data && data.suggestions) || [];
    if (sugg.length === 0) { closeAcDropdown(); return; }
    els.acDropdown.innerHTML = '';
    sugg.forEach(function (item) {
      var row = $('<div class="ac-item"></div>');
      var tag = $('<span class="ac-tag"></span>');
      tag.textContent = item.type === 'category' ? '카테고리' : '상품';
      var label = document.createElement('span');
      label.textContent = item.text;
      row.appendChild(tag);
      row.appendChild(label);
      if (item.corrected) {
        var hint = $('<span class="ac-corrected"></span>');
        hint.textContent = '(이 검색어를 찾으셨나요?)';
        row.appendChild(hint);
      }
      row.addEventListener('mousedown', function (e) {
        e.preventDefault();
        closeAcDropdown();
        els.input.value = '';
        doProductSearch(item.text);
      });
      els.acDropdown.appendChild(row);
    });
    els.acDropdown.classList.add('open');
  }

  var acTimer = null;
  function handleSearchInput() {
    if (mode !== 'search' || !els.acDropdown) { closeAcDropdown(); return; }
    var q = els.input.value.trim();
    clearTimeout(acTimer);
    if (!q) { closeAcDropdown(); return; }
    acTimer = setTimeout(function () {
      fetchWithTimeout(CTX + '/hat/suggest.jsp?q=' + encodeURIComponent(q), { method: 'GET' }, 8000)
        .then(function (res) { return res.ok ? res.json() : { suggestions: [] }; })
        .then(renderAcDropdown)
        .catch(function () { closeAcDropdown(); });
    }, 200);
  }

  function doProductSearch(q) {
    addUserMsg(q);
    var typingEl = addTyping();
    fetchWithTimeout(CTX + '/chat/search.jsp?q=' + encodeURIComponent(q), { method: 'GET' }, 10000)
      .then(function (res) {
        if (!res.ok) throw new Error('HTTP ' + res.status);
        return res.json();
      })
      .then(function (data) {
        typingEl.remove();
        var items = (data && data.items) || [];
        if (items.length === 0) {
          addBotMsg('"' + q + '"와 일치하는 상품을 찾지 못했습니다. 다른 키워드로 시도해보세요.');
          return;
        }
        addBotMsg(items.length + '개의 상품을 찾았습니다:');
        items.forEach(function (it) {
          var card = $('<a class="hs-result-card"></a>');
          card.href = CTX + it.url;
          var img = document.createElement('img');
          img.src = it.image || (CTX + '/images/no-image.png');
          img.alt = it.name || '';
          img.onerror = function () { this.onerror = null; this.src = CTX + '/images/no-image.png'; };
          var info = $('<div class="hs-result-info"></div>');
          var nameEl = $('<div class="hs-result-name"></div>');
          nameEl.textContent = it.name || '';
          var priceEl = $('<div class="hs-result-price"></div>');
          priceEl.textContent = (it.price != null ? it.price.toLocaleString('ko-KR') + '원' : '');
          info.appendChild(nameEl);
          info.appendChild(priceEl);
          var go = $('<span class="hs-result-go">바로가기 →</span>');
          card.appendChild(img);
          card.appendChild(info);
          card.appendChild(go);
          els.body.appendChild(card);
        });
        scrollToBottom();
      })
      .catch(function () {
        typingEl.remove();
        addBotMsg('상품 검색 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      });
  }

  function renderRefundMode() {
    mode = 'refund';
    closeAcDropdown();
    addBotMsg('환불을 원하시는 사유를 선택해주세요.');
    clearQuick();
    refundReasons.forEach(function (r) {
      addQuickBtn(r.label, function () {
        addUserMsg(r.label);
        addBotMsg(refundGuide[r.code] + '\n\n영업일 기준 3~5일 내(회사 사정에 따라 변동될 수 있음)로 환불이 처리됩니다. 마이페이지 > 주문 내역에서 해당 주문을 선택해 환불 신청을 진행해주세요.');
        clearQuick();
        var goBtn = $('<button type="button" class="hs-quick-btn"></button>');
        goBtn.textContent = '마이페이지로 이동';
        goBtn.addEventListener('click', function () { window.location.href = CTX + '/member/mypage.jsp?tab=orders'; });
        els.quick.appendChild(goBtn);
        renderBackBtn();
      });
    });
    renderBackBtn();
  }

  function renderInquiryMode() {
    mode = 'inquiry';
    closeAcDropdown();
    clearQuick();
    addBotMsg('고객센터로 문의 내용을 남겨주시면 확인 후 답변드리겠습니다.');
    var card = $(
      '<div class="hs-inquiry-form">' +
        '<input type="text" id="hsInqName" placeholder="이름" maxlength="50">' +
        '<input type="email" id="hsInqEmail" placeholder="이메일" maxlength="100">' +
        '<input type="text" id="hsInqTitle" placeholder="제목" maxlength="200">' +
        '<textarea id="hsInqContent" rows="3" placeholder="문의 내용을 입력해주세요." maxlength="2000"></textarea>' +
        '<button type="button">문의 보내기</button>' +
      '</div>'
    );
    els.body.appendChild(card);
    scrollToBottom();

    card.querySelector('button').addEventListener('click', function () {
      var name = card.querySelector('#hsInqName').value.trim();
      var email = card.querySelector('#hsInqEmail').value.trim();
      var title = card.querySelector('#hsInqTitle').value.trim();
      var content = card.querySelector('#hsInqContent').value.trim();

      if (!name || !email || !title || !content) {
        addBotMsg('이름, 이메일, 제목, 내용을 모두 입력해주세요.');
        return;
      }
      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        addBotMsg('이메일 형식을 확인해주세요.');
        return;
      }

      var btn = card.querySelector('button');
      btn.disabled = true;
      btn.textContent = '전송 중...';

      fetchWithTimeout(CTX + '/chat/inquiry.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: 'name=' + encodeURIComponent(name) + '&email=' + encodeURIComponent(email) +
              '&title=' + encodeURIComponent(title) + '&content=' + encodeURIComponent(content)
      }, 10000).then(function (res) {
        if (!res.ok) throw new Error('HTTP ' + res.status);
        return res.json();
      }).then(function (data) {
        card.remove();
        if (data && data.ok) {
          addBotMsg('문의가 정상적으로 접수되었습니다. 빠르게 확인 후 답변드리겠습니다.');
        } else {
          addBotMsg((data && data.error) || '문의 접수 중 문제가 발생했습니다. 잠시 후 다시 시도해주세요.');
        }
        clearQuick();
        renderBackBtn();
      }).catch(function () {
        btn.disabled = false;
        btn.textContent = '문의 보내기';
        addBotMsg('네트워크 오류로 문의 접수에 실패했습니다. 잠시 후 다시 시도해주세요.');
      });
    });
  }

  function handleSubmit(e) {
    e.preventDefault();
    var text = els.input.value.trim();
    if (!text) return;
    els.input.value = '';
    closeAcDropdown();

    if (mode === 'search') {
      doProductSearch(text);
    } else {
      askAI(text);
    }
  }

  function openPanel() {
    els.root.classList.add('open');
    els.panel.hidden = false;
    if (!els.body.hasChildNodes()) {
      addBotMsg('안녕하세요! HATSHOP 고객 상담 챗봇입니다 🎩\n무엇을 도와드릴까요?');
      renderMenu();
    }
    els.input.focus();
  }

  function closePanel() {
    els.root.classList.remove('open');
    els.panel.hidden = true;
  }

  function init() {
    els.root = document.getElementById('hsChatbot');
    if (!els.root) return;
    els.toggle = document.getElementById('hsChatToggle');
    els.panel = document.getElementById('hsChatPanel');
    els.close = document.getElementById('hsChatClose');
    els.body = document.getElementById('hsChatBody');
    els.quick = document.getElementById('hsChatQuick');
    els.form = document.getElementById('hsChatForm');
    els.input = document.getElementById('hsChatInput');
    els.acDropdown = document.getElementById('hsAcDropdown');

    els.toggle.addEventListener('click', openPanel);
    els.close.addEventListener('click', closePanel);
    els.form.addEventListener('submit', handleSubmit);
    els.input.addEventListener('input', handleSearchInput);
    document.addEventListener('mousedown', function (e) {
      if (els.acDropdown && !els.acDropdown.contains(e.target) && e.target !== els.input) closeAcDropdown();
    });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && !els.panel.hidden) closePanel();
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
