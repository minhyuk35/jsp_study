-- ============================================================
-- HatShop DB Schema v1.0
-- MySQL 8.0 / UTF-8mb4
-- ============================================================
-- ⚠️  BCrypt 해시 안내
--   샘플 INSERT의 해시는 placeholder입니다.
--   실제 실행 전 BCryptUtil.java의 main()을 먼저 돌려
--   출력된 해시로 교체하거나, README의 초기화 가이드를 따르세요.
-- ============================================================

DROP DATABASE IF EXISTS hatshop;
CREATE DATABASE hatshop
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE hatshop;

-- ──────────────────────────────
-- 1. 회원
-- ──────────────────────────────
CREATE TABLE member (
    member_id   VARCHAR(20)              NOT NULL COMMENT '아이디 (PK)',
    member_pw   VARCHAR(100)             NOT NULL COMMENT '비밀번호 (BCrypt 60자)',
    member_name VARCHAR(30)              NOT NULL COMMENT '이름',
    email       VARCHAR(100)             NOT NULL COMMENT '이메일',
    phone       VARCHAR(20)                       COMMENT '전화번호',
    addr        VARCHAR(200)                      COMMENT '주소',
    grade       ENUM('NORMAL','ADMIN')   NOT NULL DEFAULT 'NORMAL' COMMENT '등급',
    reg_date    DATETIME                 NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
    PRIMARY KEY (member_id),
    UNIQUE KEY uq_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원';

-- ──────────────────────────────
-- 2. 모자 상품
-- ──────────────────────────────
CREATE TABLE hat (
    hat_no       INT           NOT NULL AUTO_INCREMENT COMMENT '상품번호 (PK)',
    hat_name     VARCHAR(100)  NOT NULL COMMENT '상품명',
    hat_price    INT           NOT NULL COMMENT '가격',
    hat_category VARCHAR(20)   NOT NULL COMMENT '카테고리',
    hat_stock    INT           NOT NULL DEFAULT 0 COMMENT '재고',
    hat_desc     TEXT                   COMMENT '설명',
    hat_image    VARCHAR(200)           COMMENT '이미지 파일명',
    reg_date     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
    PRIMARY KEY (hat_no),
    INDEX idx_category (hat_category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='모자 상품';

-- ──────────────────────────────
-- 3. 장바구니
-- ──────────────────────────────
CREATE TABLE cart (
    cart_no   INT         NOT NULL AUTO_INCREMENT COMMENT '장바구니번호 (PK)',
    member_id VARCHAR(20) NOT NULL COMMENT '회원 (FK)',
    hat_no    INT         NOT NULL COMMENT '상품 (FK)',
    cart_qty  INT         NOT NULL DEFAULT 1 COMMENT '수량',
    add_date  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '담은날짜',
    PRIMARY KEY (cart_no),
    UNIQUE KEY uq_member_hat (member_id, hat_no),
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE,
    FOREIGN KEY (hat_no)    REFERENCES hat(hat_no)       ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='장바구니';

-- ──────────────────────────────
-- 4. 주문 헤더
-- ──────────────────────────────
CREATE TABLE orders (
    order_no     INT           NOT NULL AUTO_INCREMENT COMMENT '주문번호 (PK)',
    member_id    VARCHAR(20)   NOT NULL COMMENT '회원 (FK)',
    order_date   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '주문일',
    order_total  INT           NOT NULL COMMENT '합계금액',
    order_status ENUM('PENDING','PAID','SHIPPING','DONE','CANCEL')
                               NOT NULL DEFAULT 'PENDING' COMMENT '주문상태',
    recv_name    VARCHAR(50)   NOT NULL COMMENT '수령인',
    recv_phone   VARCHAR(20)   NOT NULL COMMENT '수령인 연락처',
    recv_addr    VARCHAR(200)  NOT NULL COMMENT '배송 주소',
    PRIMARY KEY (order_no),
    INDEX idx_member (member_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='주문';

-- ──────────────────────────────
-- 5. 주문 상세
-- ──────────────────────────────
CREATE TABLE order_detail (
    detail_no    INT NOT NULL AUTO_INCREMENT COMMENT '상세번호 (PK)',
    order_no     INT NOT NULL COMMENT '주문번호 (FK)',
    hat_no       INT NOT NULL COMMENT '상품번호 (FK)',
    detail_qty   INT NOT NULL COMMENT '수량',
    detail_price INT NOT NULL COMMENT '주문 시점 단가',
    PRIMARY KEY (detail_no),
    FOREIGN KEY (order_no) REFERENCES orders(order_no) ON DELETE CASCADE,
    FOREIGN KEY (hat_no)   REFERENCES hat(hat_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='주문상세';

-- ──────────────────────────────
-- 6. 게시판
-- ──────────────────────────────
CREATE TABLE board (
    board_no      INT          NOT NULL AUTO_INCREMENT COMMENT '게시글번호 (PK)',
    member_id     VARCHAR(20)  NOT NULL COMMENT '작성자 (FK)',
    board_title   VARCHAR(200) NOT NULL COMMENT '제목',
    board_content TEXT         NOT NULL COMMENT '내용',
    board_type    ENUM('NORMAL','NOTICE') NOT NULL DEFAULT 'NORMAL' COMMENT '게시글 유형',
    board_hit     INT          NOT NULL DEFAULT 0 COMMENT '조회수',
    reg_date      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    PRIMARY KEY (board_no),
    INDEX idx_member (member_id),
    INDEX idx_type   (board_type),
    FOREIGN KEY (member_id) REFERENCES member(member_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='게시판';


-- ============================================================
-- 샘플 데이터
-- ============================================================
-- ⚠️ BCrypt 해시 교체 방법:
--   1. BCryptUtil.java 컴파일 후 main() 실행
--   2. 출력된 해시를 아래 INSERT의 해시 자리에 붙여넣기
--   3. 원문 비밀번호: admin → admin1234 / user1/user2 → user1234
-- ============================================================

-- 관리자 계정 (원문: admin1234)
INSERT INTO member (member_id, member_pw, member_name, email, phone, addr, grade) VALUES
('admin',
 '$2a$10$HASH_REPLACE_ME_RUN_BCryptUtil_admin1234_____________OK',
 '관리자', 'admin@hatshop.com', '010-0000-0000', '서울시 강남구 테헤란로 1', 'ADMIN');

-- 일반 회원 2명 (원문: user1234)
INSERT INTO member (member_id, member_pw, member_name, email, phone, addr, grade) VALUES
('hong',
 '$2a$10$HASH_REPLACE_ME_RUN_BCryptUtil_user1234______________OK',
 '홍길동', 'hong@example.com', '010-1111-2222', '서울시 마포구 합정로 10', 'NORMAL'),
('kim',
 '$2a$10$HASH_REPLACE_ME_RUN_BCryptUtil_user1234______________OK',
 '김모자', 'kim@example.com',  '010-3333-4444', '경기도 성남시 분당구 판교로 5', 'NORMAL');

-- 모자 상품 200개 (카테고리별 40개)

INSERT INTO hat (hat_name, hat_price, hat_category, hat_stock, hat_desc, hat_image)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 40
)
SELECT
    CONCAT(base_name, ' ', LPAD(n, 2, '0')) AS hat_name,
    15000 + (((n * 1730) + 2000) % 74000) AS hat_price,
    '볼캡' AS hat_category,
    CASE
        WHEN n = 7 THEN 0
        WHEN n IN (14, 21, 28, 35) THEN 4
        ELSE (((n * 7) + 3) % 47) + 3
    END AS hat_stock,
    CASE MOD(n - 1, 4)
        WHEN 0 THEN '탄탄한 코튼 트윌 소재로 형태가 쉽게 무너지지 않습니다. 매일 쓰기 좋은 균형 잡힌 실루엣으로 부담 없이 착용할 수 있습니다.'
        WHEN 1 THEN '앞면 자수 포인트와 부드러운 곡선 브림이 안정적인 인상을 만듭니다. 캐주얼부터 스트릿까지 폭넓게 활용하기 좋습니다.'
        WHEN 2 THEN '가벼운 착용감과 조절 가능한 스트랩으로 실용성을 높였습니다. 자연스러운 워싱감이 데일리 룩에 편안함을 더합니다.'
        ELSE '미니멀한 패널 구성으로 깔끔한 인상이 살아납니다. 사계절 내내 가볍게 쓰기 좋은 기본 아이템입니다.'
    END AS hat_desc,
    CONCAT('https://images.unsplash.com/photo-',
        CASE MOD(n - 1, 5)
            WHEN 0 THEN '1521369909029-2afed882baee'
            WHEN 1 THEN '1576871337632-b9aef4c17ab9'
            WHEN 2 THEN '1571945153237-4929e783af4a'
            WHEN 3 THEN '1604871000636-074fa5117945'
            ELSE '1529958030586-423a96e1c4f8'
        END,
    '?w=600&q=80&fit=crop') AS hat_image
FROM seq
CROSS JOIN (SELECT 'Classic Logo Cap' AS base_name) b;

INSERT INTO hat (hat_name, hat_price, hat_category, hat_stock, hat_desc, hat_image)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 40
)
SELECT
    CONCAT(base_name, ' ', LPAD(n, 2, '0')),
    15000 + (((n * 1910) + 3500) % 74000),
    '버킷햇',
    CASE
        WHEN n = 7 THEN 0
        WHEN n IN (14, 21, 28, 35) THEN 4
        ELSE (((n * 9) + 5) % 47) + 3
    END,
    CASE MOD(n - 1, 4)
        WHEN 0 THEN '부드러운 라인과 넓은 챙이 얼굴을 편안하게 감싸줍니다. 가벼운 코튼 소재로 여름 시즌에도 부담 없이 쓰기 좋습니다.'
        WHEN 1 THEN '접어 들기 쉬운 실루엣으로 여행이나 휴대에 유리합니다. 미니멀한 디자인이라 셔츠와 티셔츠 모두에 잘 어울립니다.'
        WHEN 2 THEN '캐주얼한 무드에 은은한 포인트를 더하는 버킷햇입니다. 통기성 좋은 원단이 장시간 착용에도 쾌적함을 유지합니다.'
        ELSE '내추럴한 질감과 안정적인 챙 길이로 균형 잡힌 스타일을 완성합니다. 도심과 휴양지 모두 자연스럽게 어울립니다.'
    END,
    CONCAT('https://images.unsplash.com/photo-',
        CASE MOD(n - 1, 5)
            WHEN 0 THEN '1556306535-0f09a537f0a3'
            WHEN 1 THEN '1529958030586-423a96e1c4f8'
            WHEN 2 THEN '1521369909029-2afed882baee'
            WHEN 3 THEN '1576871337632-b9aef4c17ab9'
            ELSE '1571945153237-4929e783af4a'
        END,
    '?w=600&q=80&fit=crop')
FROM seq
CROSS JOIN (SELECT 'Urban Bucket Hat' AS base_name) b;

INSERT INTO hat (hat_name, hat_price, hat_category, hat_stock, hat_desc, hat_image)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 40
)
SELECT
    CONCAT(base_name, ' ', LPAD(n, 2, '0')),
    15000 + (((n * 1650) + 5200) % 74000),
    '베레모',
    CASE
        WHEN n = 7 THEN 0
        WHEN n IN (14, 21, 28, 35) THEN 4
        ELSE (((n * 11) + 7) % 47) + 3
    END,
    CASE MOD(n - 1, 4)
        WHEN 0 THEN '부드럽게 떨어지는 형태가 얼굴선을 우아하게 정리해 줍니다. 가볍게 눌러 쓰면 자연스러운 프렌치 무드가 살아납니다.'
        WHEN 1 THEN '울과 니트 계열의 질감을 떠올리게 하는 클래식한 감성이 특징입니다. 모던한 코디에 한 끗 차이를 더하기 좋습니다.'
        WHEN 2 THEN '편안한 착용감과 세련된 볼륨감이 균형을 이룹니다. 포멀한 아우터와 함께 매치하면 분위기가 한층 깊어집니다.'
        ELSE '일상복에 과하지 않은 포인트를 주는 베레모입니다. 간결한 디자인이라 계절감에 맞춰 다양한 스타일링이 가능합니다.'
    END,
    CONCAT('https://images.unsplash.com/photo-',
        CASE MOD(n - 1, 5)
            WHEN 0 THEN '1529958030586-423a96e1c4f8'
            WHEN 1 THEN '1521369909029-2afed882baee'
            WHEN 2 THEN '1576871337632-b9aef4c17ab9'
            WHEN 3 THEN '1571945153237-4929e783af4a'
            ELSE '1604871000636-074fa5117945'
        END,
    '?w=600&q=80&fit=crop')
FROM seq
CROSS JOIN (SELECT 'Paris Line Beret' AS base_name) b;

INSERT INTO hat (hat_name, hat_price, hat_category, hat_stock, hat_desc, hat_image)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 40
)
SELECT
    CONCAT(base_name, ' ', LPAD(n, 2, '0')),
    15000 + (((n * 2040) + 6100) % 74000),
    '페도라',
    CASE
        WHEN n = 7 THEN 0
        WHEN n IN (14, 21, 28, 35) THEN 4
        ELSE (((n * 13) + 11) % 47) + 3
    END,
    CASE MOD(n - 1, 4)
        WHEN 0 THEN '단정한 크라운과 챙 라인이 클래식한 무드를 완성합니다. 재킷이나 코트와 매치하면 존재감이 분명해집니다.'
        WHEN 1 THEN '부드럽게 잡힌 곡선이 얼굴형을 자연스럽게 보완합니다. 데일리 룩에 우아한 포인트를 더하고 싶을 때 적합합니다.'
        WHEN 2 THEN '탄력 있는 형태감과 안정적인 밸런스로 오래 써도 실루엣이 흐트러지지 않습니다. 차분하면서도 세련된 인상을 줍니다.'
        ELSE '도시적인 감성을 살리기 쉬운 정제된 디자인입니다. 포멀한 셔츠부터 캐주얼한 니트까지 폭넓게 어울립니다.'
    END,
    CONCAT('https://images.unsplash.com/photo-',
        CASE MOD(n - 1, 5)
            WHEN 0 THEN '1604871000636-074fa5117945'
            WHEN 1 THEN '1529958030586-423a96e1c4f8'
            WHEN 2 THEN '1521369909029-2afed882baee'
            WHEN 3 THEN '1576871337632-b9aef4c17ab9'
            ELSE '1571945153237-4929e783af4a'
        END,
    '?w=600&q=80&fit=crop')
FROM seq
CROSS JOIN (SELECT 'City Felt Fedora' AS base_name) b;

INSERT INTO hat (hat_name, hat_price, hat_category, hat_stock, hat_desc, hat_image)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 40
)
SELECT
    CONCAT(base_name, ' ', LPAD(n, 2, '0')),
    15000 + (((n * 1780) + 7800) % 74000),
    '스냅백',
    CASE
        WHEN n = 7 THEN 0
        WHEN n IN (14, 21, 28, 35) THEN 4
        ELSE (((n * 15) + 13) % 47) + 3
    END,
    CASE MOD(n - 1, 4)
        WHEN 0 THEN '평평한 브림과 뚜렷한 로고 포인트가 스트릿 무드를 강조합니다. 스포티한 룩부터 힙한 데일리룩까지 폭넓게 소화합니다.'
        WHEN 1 THEN '단단한 앞판 구조가 형태를 안정적으로 잡아줍니다. 캐주얼한 상의와 함께 매치하면 경쾌한 인상을 더합니다.'
        WHEN 2 THEN '조절 가능한 스트랩 덕분에 착용감이 편안합니다. 과하지 않은 존재감으로 꾸준히 손이 가는 아이템입니다.'
        ELSE '도시적인 컬러감과 깔끔한 라인이 어우러져 활용도가 높습니다. 가벼운 외출에도 스타일을 또렷하게 마무리합니다.'
    END,
    CONCAT('https://images.unsplash.com/photo-',
        CASE MOD(n - 1, 5)
            WHEN 0 THEN '1571945153237-4929e783af4a'
            WHEN 1 THEN '1604871000636-074fa5117945'
            WHEN 2 THEN '1521369909029-2afed882baee'
            WHEN 3 THEN '1576871337632-b9aef4c17ab9'
            ELSE '1529958030586-423a96e1c4f8'
        END,
    '?w=600&q=80&fit=crop')
FROM seq
CROSS JOIN (SELECT 'Bold Logo Snapback' AS base_name) b;


-- ============================================================
-- 빠른 개발/테스트용 (BCrypt 미사용 — 테스트 후 삭제 권장)
-- ============================================================
-- 아래 블록은 BCrypt 교체 전 로그인 테스트가 필요할 때만 사용하세요.
-- DBConn 없이 MySQL CLI에서 실행:
--   UPDATE member SET member_pw = 'admin1234' WHERE member_id = 'admin';
-- 단, 실서비스에서는 절대 평문 저장 금지!
-- ============================================================
