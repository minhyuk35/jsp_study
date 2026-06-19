-- HatShop 샘플 데이터 200개 (카테고리별 40개)
-- 실행: mysql -u root -p hatshop < sample_data.sql

USE hatshop;

-- 볼캡 40개 ─────────────────────────────────────────────────────────────────
INSERT INTO hat (hat_name, hat_price, hat_category, hat_stock, hat_desc, hat_image) VALUES
('빈티지 워시드 볼캡', 32000, '볼캡', 15, '빈티지 워싱 처리로 자연스러운 에이징 효과', 'https://images.unsplash.com/photo-1521369909029-2afed882baee?w=600&q=80&fit=crop'),
('클래식 코튼 볼캡', 25000, '볼캡', 30, '100% 코튼 소재의 편안한 착용감', 'https://images.unsplash.com/photo-1521369909029-2afed882baee?w=600&q=80&fit=crop'),
('메쉬 스냅 볼캡', 28000, '볼캡', 0, '통기성 메쉬 소재로 여름철 착용에 최적', 'https://images.unsplash.com/photo-1521369909029-2afed882baee?w=600&q=80&fit=crop'),
('스트라이프 볼캡', 29000, '볼캡', 8, '세련된 스트라이프 패턴의 볼캡', 'https://images.unsplash.com/photo-1521369909029-2afed882baee?w=600&q=80&fit=crop'),

('미니멀 로고 볼캡', 35000, '볼캡', 20, '심플한 자수 로고로 완성된 미니멀 디자인', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80&fit=crop'),
('레트로 에디션 볼캡', 39000, '볼캡', 12, '레트로 감성을 담은 빈티지 스타일 볼캡', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80&fit=crop'),
('스포츠 드라이핏 볼캡', 42000, '볼캡', 25, '땀을 빠르게 흡수하는 드라이핏 소재', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80&fit=crop'),
('어반 캐주얼 볼캡', 31000, '볼캡', 0, '도시적 감성의 캐주얼 볼캡', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80&fit=crop'),

('프리미엄 울 블렌드 볼캡', 65000, '볼캡', 5, '울 혼방 소재로 고급스러운 텍스처 구현', 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600&q=80&fit=crop'),
('서머 코튼 볼캡', 22000, '볼캡', 40, '가볍고 시원한 여름용 코튼 볼캡', 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600&q=80&fit=crop'),
('워시드 데님 볼캡', 45000, '볼캡', 10, '데님 소재에 워싱 처리로 자연스러운 느낌', 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600&q=80&fit=crop'),
('미드 크라운 볼캡', 33000, '볼캡', 18, '적당한 높이의 크라운으로 무난한 핏', 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600&q=80&fit=crop'),

('로우 프로파일 볼캡', 36000, '볼캡', 22, '낮은 크라운으로 깔끔하고 세련된 실루엣', 'https://images.unsplash.com/photo-1534215754734-18e55d13e346?w=600&q=80&fit=crop'),
('플랫 브림 볼캡', 38000, '볼캡', 0, '납작한 브림으로 스트리트 패션에 완벽', 'https://images.unsplash.com/photo-1534215754734-18e55d13e346?w=600&q=80&fit=crop'),
('6패널 볼캡', 27000, '볼캡', 35, '정통 6패널 구조의 기본 볼캡', 'https://images.unsplash.com/photo-1534215754734-18e55d13e346?w=600&q=80&fit=crop'),
('5패널 캠프 캡', 30000, '볼캡', 14, '5패널 구조로 독특한 실루엣 연출', 'https://images.unsplash.com/photo-1534215754734-18e55d13e346?w=600&q=80&fit=crop'),

('트러커 볼캡', 29000, '볼캡', 28, '앞면 폼 소재에 메쉬 뒷면의 클래식 트러커캡', 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=600&q=80&fit=crop'),
('골프 볼캡', 55000, '볼캡', 7, '자외선 차단 기능의 프리미엄 골프 볼캡', 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=600&q=80&fit=crop'),
('러닝 볼캡', 48000, '볼캡', 16, '경량 소재와 통기성 설계로 달리기에 최적', 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=600&q=80&fit=crop'),
('투톤 컬러 볼캡', 34000, '볼캡', 0, '대비되는 두 컬러로 포인트를 주는 볼캡', 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=600&q=80&fit=crop'),

('타이다이 볼캡', 37000, '볼캡', 9, '개성 넘치는 타이다이 패턴의 유니크한 볼캡', 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=600&q=80&fit=crop'),
('자수 로고 볼캡', 42000, '볼캡', 20, '정교한 자수 로고로 완성도를 높인 볼캡', 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=600&q=80&fit=crop'),
('패치 볼캡', 39000, '볼캡', 11, '개성 있는 와펜 패치 장식의 볼캡', 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=600&q=80&fit=crop'),
('코듀로이 볼캡', 43000, '볼캡', 6, '고급스러운 코듀로이 소재의 빈티지 볼캡', 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=600&q=80&fit=crop'),

('캔버스 볼캡', 26000, '볼캡', 33, '튼튼하고 내구성 좋은 캔버스 소재 볼캡', 'https://images.unsplash.com/photo-1604871000636-074fa5117945?w=600&q=80&fit=crop'),
('나일론 볼캡', 35000, '볼캡', 17, '가볍고 방수 기능의 나일론 소재 볼캡', 'https://images.unsplash.com/photo-1604871000636-074fa5117945?w=600&q=80&fit=crop'),
('리사이클 볼캡', 52000, '볼캡', 8, '재활용 소재로 만든 친환경 볼캡', 'https://images.unsplash.com/photo-1604871000636-074fa5117945?w=600&q=80&fit=crop'),
('오가닉 코튼 볼캡', 47000, '볼캡', 13, '유기농 코튼으로 제작된 에코 프렌들리 볼캡', 'https://images.unsplash.com/photo-1604871000636-074fa5117945?w=600&q=80&fit=crop'),

('카모 볼캡', 32000, '볼캡', 0, '밀리터리 감성의 카모플라주 패턴 볼캡', 'https://images.unsplash.com/photo-1607522370275-f14206abe5d3?w=600&q=80&fit=crop'),
('체크 패턴 볼캡', 36000, '볼캡', 24, '클래식한 체크 패턴으로 스타일리시한 볼캡', 'https://images.unsplash.com/photo-1607522370275-f14206abe5d3?w=600&q=80&fit=crop'),
('모노그램 볼캡', 58000, '볼캡', 4, '모노그램 패턴으로 럭셔리한 느낌의 볼캡', 'https://images.unsplash.com/photo-1607522370275-f14206abe5d3?w=600&q=80&fit=crop'),
('솔리드 블랙 볼캡', 23000, '볼캡', 50, '언제 어디서나 활용 가능한 기본 블랙 볼캡', 'https://images.unsplash.com/photo-1607522370275-f14206abe5d3?w=600&q=80&fit=crop'),

('레인보우 볼캡', 34000, '볼캡', 15, '밝고 화사한 레인보우 컬러 자수 볼캡', 'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=600&q=80&fit=crop'),
('아웃도어 볼캡', 49000, '볼캡', 19, '등산 및 야외 활동에 최적화된 기능성 볼캡', 'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=600&q=80&fit=crop'),
('스트리트 에디션 볼캡', 44000, '볼캡', 0, '스트리트 컬처에서 영감 받은 한정판 볼캡', 'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=600&q=80&fit=crop'),
('시그니처 볼캡', 75000, '볼캡', 3, '디자이너 시그니처가 담긴 프리미엄 볼캡', 'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=600&q=80&fit=crop'),

('헤리티지 볼캡', 62000, '볼캡', 10, '브랜드 헤리티지를 담은 클래식 볼캡', 'https://images.unsplash.com/photo-1618517351616-38fb9952b7fb?w=600&q=80&fit=crop'),
('어드벤처 볼캡', 40000, '볼캡', 21, '모험과 탐험을 위한 기능성 볼캡', 'https://images.unsplash.com/photo-1618517351616-38fb9952b7fb?w=600&q=80&fit=crop'),
('스포츠 클럽 볼캡', 28000, '볼캡', 45, '스포츠 클럽 감성의 캐주얼 볼캡', 'https://images.unsplash.com/photo-1618517351616-38fb9952b7fb?w=600&q=80&fit=crop'),
('원 포인트 볼캡', 31000, '볼캡', 27, '전면 원 포인트 로고로 깔끔한 스타일링', 'https://images.unsplash.com/photo-1618517351616-38fb9952b7fb?w=600&q=80&fit=crop');

-- 버킷햇 40개 ─────────────────────────────────────────────────────────────────
INSERT INTO hat (hat_name, hat_price, hat_category, hat_stock, hat_desc, hat_image) VALUES
('코튼 버킷햇', 28000, '버킷햇', 20, '부드러운 코튼 소재의 기본 버킷햇', 'https://images.unsplash.com/photo-1556306535-0f09a537f0a3?w=600&q=80&fit=crop'),
('캔버스 버킷햇', 32000, '버킷햇', 15, '튼튼한 캔버스 소재로 오래 사용 가능한 버킷햇', 'https://images.unsplash.com/photo-1556306535-0f09a537f0a3?w=600&q=80&fit=crop'),
('데님 버킷햇', 38000, '버킷햇', 10, '데님 소재로 캐주얼하고 트렌디한 버킷햇', 'https://images.unsplash.com/photo-1556306535-0f09a537f0a3?w=600&q=80&fit=crop'),
('리버시블 버킷햇', 45000, '버킷햇', 12, '양면으로 착용 가능한 실용적인 리버시블 버킷햇', 'https://images.unsplash.com/photo-1556306535-0f09a537f0a3?w=600&q=80&fit=crop'),
('나일론 버킷햇', 35000, '버킷햇', 0, '가볍고 방수되는 나일론 소재 버킷햇', 'https://images.unsplash.com/photo-1556306535-0f09a537f0a3?w=600&q=80&fit=crop'),
('워시드 버킷햇', 39000, '버킷햇', 8, '빈티지 워싱 처리된 자연스러운 버킷햇', 'https://images.unsplash.com/photo-1556306535-0f09a537f0a3?w=600&q=80&fit=crop'),
('스트라이프 버킷햇', 33000, '버킷햇', 25, '트렌디한 스트라이프 패턴의 버킷햇', 'https://images.unsplash.com/photo-1556306535-0f09a537f0a3?w=600&q=80&fit=crop'),
('체크 버킷햇', 36000, '버킷햇', 18, '클래식 체크 패턴으로 스타일리시한 버킷햇', 'https://images.unsplash.com/photo-1556306535-0f09a537f0a3?w=600&q=80&fit=crop'),

('카모 버킷햇', 34000, '버킷햇', 14, '밀리터리 스타일의 카모플라주 버킷햇', 'https://images.unsplash.com/photo-1529958030-73c0-73c0fade?w=600&q=80&fit=crop'),
('타이다이 버킷햇', 37000, '버킷햇', 0, '개성 있는 타이다이 패턴의 버킷햇', 'https://images.unsplash.com/photo-1529958030-73c0-73c0fade?w=600&q=80&fit=crop'),
('플리스 버킷햇', 48000, '버킷햇', 6, '포근한 플리스 소재의 겨울용 버킷햇', 'https://images.unsplash.com/photo-1529958030-73c0-73c0fade?w=600&q=80&fit=crop'),
('테리 버킷햇', 29000, '버킷햇', 30, '테리 소재로 여름 해변에 어울리는 버킷햇', 'https://images.unsplash.com/photo-1529958030-73c0-73c0fade?w=600&q=80&fit=crop'),
('코듀로이 버킷햇', 42000, '버킷햇', 9, '고급스러운 코듀로이 소재의 빈티지 버킷햇', 'https://images.unsplash.com/photo-1529958030-73c0-73c0fade?w=600&q=80&fit=crop'),
('리넨 버킷햇', 41000, '버킷햇', 11, '시원하고 가벼운 리넨 소재의 서머 버킷햇', 'https://images.unsplash.com/photo-1529958030-73c0-73c0fade?w=600&q=80&fit=crop'),
('울 버킷햇', 55000, '버킷햇', 7, '따뜻한 울 소재로 가을·겨울에 최적인 버킷햇', 'https://images.unsplash.com/photo-1529958030-73c0-73c0fade?w=600&q=80&fit=crop'),
('자카드 버킷햇', 62000, '버킷햇', 4, '고급 자카드 패브릭으로 제작된 럭셔리 버킷햇', 'https://images.unsplash.com/photo-1529958030-73c0-73c0fade?w=600&q=80&fit=crop'),

('패딩 버킷햇', 58000, '버킷햇', 5, '퀼팅 패딩 소재로 따뜻한 겨울용 버킷햇', 'https://images.unsplash.com/photo-1512327428705-28db0954aafa?w=600&q=80&fit=crop'),
('메쉬 버킷햇', 27000, '버킷햇', 35, '통기성 메쉬로 여름 활동에 최적인 버킷햇', 'https://images.unsplash.com/photo-1512327428705-28db0954aafa?w=600&q=80&fit=crop'),
('오가닉 버킷햇', 49000, '버킷햇', 13, '유기농 소재로 제작된 친환경 버킷햇', 'https://images.unsplash.com/photo-1512327428705-28db0954aafa?w=600&q=80&fit=crop'),
('클래식 버킷햇', 24000, '버킷햇', 40, '어느 스타일에도 잘 어울리는 클래식 버킷햇', 'https://images.unsplash.com/photo-1512327428705-28db0954aafa?w=600&q=80&fit=crop'),
('빈티지 버킷햇', 43000, '버킷햇', 0, '빈티지 감성이 물씬 풍기는 레트로 버킷햇', 'https://images.unsplash.com/photo-1512327428705-28db0954aafa?w=600&q=80&fit=crop'),
('어반 버킷햇', 38000, '버킷햇', 16, '도심의 감성을 담은 스트리트 버킷햇', 'https://images.unsplash.com/photo-1512327428705-28db0954aafa?w=600&q=80&fit=crop'),
('페스티벌 버킷햇', 31000, '버킷햇', 22, '페스티벌에서 눈에 띄는 컬러풀한 버킷햇', 'https://images.unsplash.com/photo-1512327428705-28db0954aafa?w=600&q=80&fit=crop'),
('비치 버킷햇', 26000, '버킷햇', 50, '해변에서 햇빛을 막아주는 넓은 챙의 버킷햇', 'https://images.unsplash.com/photo-1512327428705-28db0954aafa?w=600&q=80&fit=crop'),

('하이킹 버킷햇', 52000, '버킷햇', 8, '기능성 소재로 등산에 최적화된 버킷햇', 'https://images.unsplash.com/photo-1503342217606-c06b2891b32d?w=600&q=80&fit=crop'),
('피싱 버킷햇', 44000, '버킷햇', 11, 'UV 차단 기능의 낚시 전용 버킷햇', 'https://images.unsplash.com/photo-1503342217606-c06b2891b32d?w=600&q=80&fit=crop'),
('서퍼 버킷햇', 36000, '버킷햇', 18, '서핑 후에도 멋스러운 캐주얼 버킷햇', 'https://images.unsplash.com/photo-1503342217606-c06b2891b32d?w=600&q=80&fit=crop'),
('플로럴 버킷햇', 34000, '버킷햇', 0, '화사한 플로럴 패턴의 여성스러운 버킷햇', 'https://images.unsplash.com/photo-1503342217606-c06b2891b32d?w=600&q=80&fit=crop'),
('그래픽 버킷햇', 40000, '버킷햇', 14, '개성 있는 그래픽 프린트의 버킷햇', 'https://images.unsplash.com/photo-1503342217606-c06b2891b32d?w=600&q=80&fit=crop'),
('로고 버킷햇', 46000, '버킷햇', 7, '선명한 로고 자수가 포인트인 버킷햇', 'https://images.unsplash.com/photo-1503342217606-c06b2891b32d?w=600&q=80&fit=crop'),
('자수 버킷햇', 53000, '버킷햇', 5, '정교한 자수 장식으로 완성도가 높은 버킷햇', 'https://images.unsplash.com/photo-1503342217606-c06b2891b32d?w=600&q=80&fit=crop'),
('투톤 버킷햇', 37000, '버킷햇', 20, '대조적인 두 컬러의 투톤 디자인 버킷햇', 'https://images.unsplash.com/photo-1503342217606-c06b2891b32d?w=600&q=80&fit=crop'),

('솔리드 화이트 버킷햇', 22000, '버킷햇', 45, '깔끔하고 순수한 화이트 솔리드 버킷햇', 'https://images.unsplash.com/photo-1529925170396-4b7f9a5f1234?w=600&q=80&fit=crop'),
('솔리드 블랙 버킷햇', 22000, '버킷햇', 45, '어디에나 매치되는 블랙 솔리드 버킷햇', 'https://images.unsplash.com/photo-1529925170396-4b7f9a5f1234?w=600&q=80&fit=crop'),
('네이비 버킷햇', 25000, '버킷햇', 30, '클래식한 네이비 컬러의 버킷햇', 'https://images.unsplash.com/photo-1529925170396-4b7f9a5f1234?w=600&q=80&fit=crop'),
('카키 버킷햇', 28000, '버킷햇', 0, '아웃도어 분위기의 카키 컬러 버킷햇', 'https://images.unsplash.com/photo-1529925170396-4b7f9a5f1234?w=600&q=80&fit=crop'),
('베이지 버킷햇', 26000, '버킷햇', 28, '따뜻하고 자연스러운 베이지 컬러 버킷햇', 'https://images.unsplash.com/photo-1529925170396-4b7f9a5f1234?w=600&q=80&fit=crop'),
('올리브 버킷햇', 29000, '버킷햇', 16, '시크하고 자연스러운 올리브 컬러 버킷햇', 'https://images.unsplash.com/photo-1529925170396-4b7f9a5f1234?w=600&q=80&fit=crop'),
('머스타드 버킷햇', 31000, '버킷햇', 12, '트렌디한 머스타드 컬러로 포인트 연출', 'https://images.unsplash.com/photo-1529925170396-4b7f9a5f1234?w=600&q=80&fit=crop'),
('테라코타 버킷햇', 33000, '버킷햇', 9, '따뜻한 어스톤 테라코타 컬러 버킷햇', 'https://images.unsplash.com/photo-1529925170396-4b7f9a5f1234?w=600&q=80&fit=crop');

-- 베레모 40개 ─────────────────────────────────────────────────────────────────
INSERT INTO hat (hat_name, hat_price, hat_category, hat_stock, hat_desc, hat_image) VALUES
('울 클래식 베레모', 45000, '베레모', 15, '고급 울 소재의 클래식한 베레모', 'https://images.unsplash.com/photo-1510598155829-2dd26f090e7a?w=600&q=80&fit=crop'),
('코튼 캐주얼 베레모', 32000, '베레모', 22, '캐주얼하게 착용 가능한 코튼 베레모', 'https://images.unsplash.com/photo-1510598155829-2dd26f090e7a?w=600&q=80&fit=crop'),
('아크릴 베레모', 24000, '베레모', 35, '가볍고 부드러운 아크릴 소재의 베레모', 'https://images.unsplash.com/photo-1510598155829-2dd26f090e7a?w=600&q=80&fit=crop'),
('앙고라 혼방 베레모', 68000, '베레모', 5, '앙고라 혼방으로 극도로 부드러운 베레모', 'https://images.unsplash.com/photo-1510598155829-2dd26f090e7a?w=600&q=80&fit=crop'),
('벨벳 베레모', 55000, '베레모', 8, '럭셔리한 벨벳 소재의 우아한 베레모', 'https://images.unsplash.com/photo-1510598155829-2dd26f090e7a?w=600&q=80&fit=crop'),
('패턴 베레모', 39000, '베레모', 0, '독특한 패턴으로 개성을 표현하는 베레모', 'https://images.unsplash.com/photo-1510598155829-2dd26f090e7a?w=600&q=80&fit=crop'),
('라지 베레모', 42000, '베레모', 12, '넉넉한 사이즈로 자유로운 스타일링이 가능한 베레모', 'https://images.unsplash.com/photo-1510598155829-2dd26f090e7a?w=600&q=80&fit=crop'),
('니트 베레모', 36000, '베레모', 20, '따뜻한 니트 소재의 겨울용 베레모', 'https://images.unsplash.com/photo-1510598155829-2dd26f090e7a?w=600&q=80&fit=crop'),

('파리지엔 베레모', 52000, '베레모', 10, '파리 감성의 정통 프렌치 스타일 베레모', 'https://images.unsplash.com/photo-1513379997-3a07e2c5-c5e8?w=600&q=80&fit=crop'),
('스코티쉬 베레모', 48000, '베레모', 7, '스코틀랜드 전통 방식으로 제작된 베레모', 'https://images.unsplash.com/photo-1513379997-3a07e2c5-c5e8?w=600&q=80&fit=crop'),
('밀리터리 베레모', 35000, '베레모', 25, '밀리터리 감성의 클래식 베레모', 'https://images.unsplash.com/photo-1513379997-3a07e2c5-c5e8?w=600&q=80&fit=crop'),
('클래식 블랙 베레모', 38000, '베레모', 30, '시대를 초월한 클래식 블랙 베레모', 'https://images.unsplash.com/photo-1513379997-3a07e2c5-c5e8?w=600&q=80&fit=crop'),
('와인 레드 베레모', 40000, '베레모', 0, '깊고 진한 와인 레드 컬러의 베레모', 'https://images.unsplash.com/photo-1513379997-3a07e2c5-c5e8?w=600&q=80&fit=crop'),
('포레스트 그린 베레모', 41000, '베레모', 14, '자연을 닮은 포레스트 그린 베레모', 'https://images.unsplash.com/photo-1513379997-3a07e2c5-c5e8?w=600&q=80&fit=crop'),
('버건디 베레모', 43000, '베레모', 9, '고급스러운 버건디 컬러의 베레모', 'https://images.unsplash.com/photo-1513379997-3a07e2c5-c5e8?w=600&q=80&fit=crop'),
('카라멜 베레모', 37000, '베레모', 18, '달콤한 카라멜 컬러로 따뜻한 느낌의 베레모', 'https://images.unsplash.com/photo-1513379997-3a07e2c5-c5e8?w=600&q=80&fit=crop'),

('차콜 그레이 베레모', 39000, '베레모', 16, '세련된 차콜 그레이 컬러의 베레모', 'https://images.unsplash.com/photo-1516762121-a9e5e94e-5e94?w=600&q=80&fit=crop'),
('크림 화이트 베레모', 34000, '베레모', 22, '깨끗하고 우아한 크림 화이트 베레모', 'https://images.unsplash.com/photo-1516762121-a9e5e94e-5e94?w=600&q=80&fit=crop'),
('소프트 핑크 베레모', 36000, '베레모', 0, '사랑스러운 소프트 핑크 컬러의 베레모', 'https://images.unsplash.com/photo-1516762121-a9e5e94e-5e94?w=600&q=80&fit=crop'),
('오트밀 베레모', 38000, '베레모', 13, '내추럴한 오트밀 컬러의 편안한 베레모', 'https://images.unsplash.com/photo-1516762121-a9e5e94e-5e94?w=600&q=80&fit=crop'),
('텍스처드 베레모', 46000, '베레모', 6, '독특한 텍스처가 살아있는 고급 베레모', 'https://images.unsplash.com/photo-1516762121-a9e5e94e-5e94?w=600&q=80&fit=crop'),
('스트라이프 베레모', 42000, '베레모', 11, '얇은 스트라이프 패턴의 트렌디한 베레모', 'https://images.unsplash.com/photo-1516762121-a9e5e94e-5e94?w=600&q=80&fit=crop'),
('하운드투스 베레모', 49000, '베레모', 8, '클래식한 하운드투스 패턴의 베레모', 'https://images.unsplash.com/photo-1516762121-a9e5e94e-5e94?w=600&q=80&fit=crop'),
('트위드 베레모', 65000, '베레모', 4, '고급 트위드 소재로 만든 정통 베레모', 'https://images.unsplash.com/photo-1516762121-a9e5e94e-5e94?w=600&q=80&fit=crop'),

('헤링본 베레모', 57000, '베레모', 6, '고전적인 헤링본 패턴의 클래식 베레모', 'https://images.unsplash.com/photo-1487412720297-5ac09e854f0a?w=600&q=80&fit=crop'),
('플레이드 베레모', 50000, '베레모', 9, '보헤미안 감성의 플레이드 패턴 베레모', 'https://images.unsplash.com/photo-1487412720297-5ac09e854f0a?w=600&q=80&fit=crop'),
('자카드 베레모', 72000, '베레모', 3, '고급 자카드 직물로 제작된 프리미엄 베레모', 'https://images.unsplash.com/photo-1487412720297-5ac09e854f0a?w=600&q=80&fit=crop'),
('오버사이즈 베레모', 44000, '베레모', 17, '루즈하게 착용 가능한 오버사이즈 베레모', 'https://images.unsplash.com/photo-1487412720297-5ac09e854f0a?w=600&q=80&fit=crop'),
('아트 베레모', 48000, '베레모', 0, '예술적 감성이 담긴 유니크한 디자인 베레모', 'https://images.unsplash.com/photo-1487412720297-5ac09e854f0a?w=600&q=80&fit=crop'),
('자수 베레모', 55000, '베레모', 7, '섬세한 자수 장식이 포인트인 베레모', 'https://images.unsplash.com/photo-1487412720297-5ac09e854f0a?w=600&q=80&fit=crop'),
('리브드 베레모', 33000, '베레모', 28, '골지 소재로 편안하게 착용 가능한 베레모', 'https://images.unsplash.com/photo-1487412720297-5ac09e854f0a?w=600&q=80&fit=crop'),
('메탈릭 베레모', 59000, '베레모', 5, '메탈릭 광택으로 드라마틱한 분위기 연출', 'https://images.unsplash.com/photo-1487412720297-5ac09e854f0a?w=600&q=80&fit=crop'),

('가죽 베레모', 89000, '베레모', 3, '진짜 가죽으로 제작된 럭셔리 베레모', 'https://images.unsplash.com/photo-1529543544282-ea669407fca1?w=600&q=80&fit=crop'),
('체크 베레모', 43000, '베레모', 15, '경쾌한 체크 패턴의 스타일리시한 베레모', 'https://images.unsplash.com/photo-1529543544282-ea669407fca1?w=600&q=80&fit=crop'),
('프린트 베레모', 38000, '베레모', 0, '독창적인 프린트 디자인의 베레모', 'https://images.unsplash.com/photo-1529543544282-ea669407fca1?w=600&q=80&fit=crop'),
('카키 베레모', 35000, '베레모', 19, '내추럴한 카키 컬러의 캐주얼 베레모', 'https://images.unsplash.com/photo-1529543544282-ea669407fca1?w=600&q=80&fit=crop'),
('네이비 베레모', 37000, '베레모', 24, '단정하고 세련된 네이비 베레모', 'https://images.unsplash.com/photo-1529543544282-ea669407fca1?w=600&q=80&fit=crop'),
('올리브 베레모', 36000, '베레모', 12, '자연스러운 올리브 컬러의 베레모', 'https://images.unsplash.com/photo-1529543544282-ea669407fca1?w=600&q=80&fit=crop'),
('프리미엄 울 베레모', 75000, '베레모', 4, '최상급 울로 제작된 프리미엄 베레모', 'https://images.unsplash.com/photo-1529543544282-ea669407fca1?w=600&q=80&fit=crop'),
('미니 베레모', 29000, '베레모', 33, '작고 아기자기한 사이즈의 미니 베레모', 'https://images.unsplash.com/photo-1529543544282-ea669407fca1?w=600&q=80&fit=crop');

-- 페도라 40개 ─────────────────────────────────────────────────────────────────
INSERT INTO hat (hat_name, hat_price, hat_category, hat_stock, hat_desc, hat_image) VALUES
('클래식 울 페도라', 65000, '페도라', 10, '정통 울 소재로 제작된 클래식 페도라', 'https://images.unsplash.com/photo-1533827432537-1f27a5373ab3?w=600&q=80&fit=crop'),
('페이퍼 페도라', 38000, '페도라', 20, '가벼운 페이퍼 소재의 여름용 페도라', 'https://images.unsplash.com/photo-1533827432537-1f27a5373ab3?w=600&q=80&fit=crop'),
('스트로 페도라', 35000, '페도라', 25, '자연 소재 스트로로 만든 내추럴 페도라', 'https://images.unsplash.com/photo-1533827432537-1f27a5373ab3?w=600&q=80&fit=crop'),
('펠트 페도라', 72000, '페도라', 6, '고급 펠트 소재의 정통 페도라', 'https://images.unsplash.com/photo-1533827432537-1f27a5373ab3?w=600&q=80&fit=crop'),
('트릴비 페도라', 55000, '페도라', 12, '짧은 브림의 트릴비 스타일 페도라', 'https://images.unsplash.com/photo-1533827432537-1f27a5373ab3?w=600&q=80&fit=crop'),
('파나마 페도라', 68000, '페도라', 8, '파나마 초 소재의 고급 수제 페도라', 'https://images.unsplash.com/photo-1533827432537-1f27a5373ab3?w=600&q=80&fit=crop'),
('레더 페도라', 85000, '페도라', 4, '진짜 가죽으로 제작된 럭셔리 페도라', 'https://images.unsplash.com/photo-1533827432537-1f27a5373ab3?w=600&q=80&fit=crop'),
('빈티지 페도라', 58000, '페도라', 0, '빈티지 감성의 에이징된 페도라', 'https://images.unsplash.com/photo-1533827432537-1f27a5373ab3?w=600&q=80&fit=crop'),

('재즈 페도라', 62000, '페도라', 9, '재즈 뮤지션에서 영감 받은 감성 페도라', 'https://images.unsplash.com/photo-1514543000875-56ecd0454f0a?w=600&q=80&fit=crop'),
('웨스턴 페도라', 75000, '페도라', 5, '미국 서부 감성의 와이드 브림 페도라', 'https://images.unsplash.com/photo-1514543000875-56ecd0454f0a?w=600&q=80&fit=crop'),
('미드 브림 페도라', 52000, '페도라', 15, '중간 사이즈 브림으로 균형 잡힌 페도라', 'https://images.unsplash.com/photo-1514543000875-56ecd0454f0a?w=600&q=80&fit=crop'),
('와이드 브림 페도라', 79000, '페도라', 7, '넓은 챙으로 드라마틱한 실루엣의 페도라', 'https://images.unsplash.com/photo-1514543000875-56ecd0454f0a?w=600&q=80&fit=crop'),
('핀치 크라운 페도라', 66000, '페도라', 11, '핀치 크라운 형태의 클래식 페도라', 'https://images.unsplash.com/photo-1514543000875-56ecd0454f0a?w=600&q=80&fit=crop'),
('플랫 크라운 페도라', 60000, '페도라', 0, '플랫 탑 크라운의 모던한 페도라', 'https://images.unsplash.com/photo-1514543000875-56ecd0454f0a?w=600&q=80&fit=crop'),
('리본 트림 페도라', 55000, '페도라', 14, '리본 트림 장식으로 우아함을 더한 페도라', 'https://images.unsplash.com/photo-1514543000875-56ecd0454f0a?w=600&q=80&fit=crop'),
('체인 디테일 페도라', 82000, '페도라', 3, '체인 디테일로 엣지 있는 스타일의 페도라', 'https://images.unsplash.com/photo-1514543000875-56ecd0454f0a?w=600&q=80&fit=crop'),

('블랙 클래식 페도라', 59000, '페도라', 18, '어떤 스타일에도 매치되는 블랙 페도라', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80&fit=crop'),
('브라운 빈티지 페도라', 64000, '페도라', 10, '따뜻한 브라운 컬러의 빈티지 페도라', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80&fit=crop'),
('그레이 모던 페도라', 67000, '페도라', 8, '세련된 그레이 컬러의 모던 페도라', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80&fit=crop'),
('카키 캐주얼 페도라', 45000, '페도라', 22, '캐주얼하게 착용 가능한 카키 페도라', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80&fit=crop'),
('네이비 블루 페도라', 62000, '페도라', 0, '단정하고 클래식한 네이비 블루 페도라', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80&fit=crop'),
('초콜릿 브라운 페도라', 70000, '페도라', 6, '달콤한 초콜릿 브라운 컬러의 고급 페도라', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80&fit=crop'),
('어반 스타일 페도라', 48000, '페도라', 16, '도시적 감성의 캐주얼 페도라', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80&fit=crop'),
('여성용 플로럴 페도라', 52000, '페도라', 12, '화사한 플로럴 패턴의 여성스러운 페도라', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80&fit=crop'),

('레더 밴드 페도라', 76000, '페도라', 5, '가죽 밴드로 포인트를 준 프리미엄 페도라', 'https://images.unsplash.com/photo-1495105787652-d7765def2af4?w=600&q=80&fit=crop'),
('패브릭 밴드 페도라', 56000, '페도라', 13, '패브릭 밴드 트림의 캐주얼 페도라', 'https://images.unsplash.com/photo-1495105787652-d7765def2af4?w=600&q=80&fit=crop'),
('다이아몬드 크라운 페도라', 69000, '페도라', 9, '다이아몬드 모양 크라운의 독특한 페도라', 'https://images.unsplash.com/photo-1495105787652-d7765def2af4?w=600&q=80&fit=crop'),
('메탈 핀 페도라', 72000, '페도라', 0, '메탈 핀 액세서리로 디테일을 살린 페도라', 'https://images.unsplash.com/photo-1495105787652-d7765def2af4?w=600&q=80&fit=crop'),
('리사이클 페도라', 58000, '페도라', 8, '환경을 생각한 재활용 소재의 친환경 페도라', 'https://images.unsplash.com/photo-1495105787652-d7765def2af4?w=600&q=80&fit=crop'),
('핸드메이드 페도라', 89000, '페도라', 2, '장인이 직접 만든 수제 핸드메이드 페도라', 'https://images.unsplash.com/photo-1495105787652-d7765def2af4?w=600&q=80&fit=crop'),
('텔레스코프 크라운 페도라', 65000, '페도라', 11, '텔레스코프 크라운의 정통 스타일 페도라', 'https://images.unsplash.com/photo-1495105787652-d7765def2af4?w=600&q=80&fit=crop'),
('1920s 클래식 페도라', 78000, '페도라', 6, '1920년대 스타일에서 영감 받은 헤리티지 페도라', 'https://images.unsplash.com/photo-1495105787652-d7765def2af4?w=600&q=80&fit=crop'),

('시즌 한정 페도라', 88000, '페도라', 3, '한정 수량으로만 제작된 시즌 스페셜 페도라', 'https://images.unsplash.com/photo-1516216073819-82e7f0e5e5e5?w=600&q=80&fit=crop'),
('프리미엄 헤이즐 페도라', 82000, '페도라', 5, '헤이즐넛 컬러의 프리미엄 소재 페도라', 'https://images.unsplash.com/photo-1516216073819-82e7f0e5e5e5?w=600&q=80&fit=crop'),
('유니섹스 미니멀 페도라', 55000, '페도라', 18, '남녀 모두에게 어울리는 미니멀 디자인 페도라', 'https://images.unsplash.com/photo-1516216073819-82e7f0e5e5e5?w=600&q=80&fit=crop'),
('차콜 그레이 페도라', 61000, '페도라', 0, '시크한 차콜 그레이 컬러의 모던 페도라', 'https://images.unsplash.com/photo-1516216073819-82e7f0e5e5e5?w=600&q=80&fit=crop'),
('오트밀 크림 페도라', 58000, '페도라', 14, '부드러운 오트밀 크림 컬러의 내추럴 페도라', 'https://images.unsplash.com/photo-1516216073819-82e7f0e5e5e5?w=600&q=80&fit=crop'),
('개그스터 스타일 페도라', 69000, '페도라', 7, '개그스터 무비에서 영감 받은 드라마틱 페도라', 'https://images.unsplash.com/photo-1516216073819-82e7f0e5e5e5?w=600&q=80&fit=crop'),
('센터 덴트 페도라', 63000, '페도라', 10, '센터 덴트 크라운의 정통 클래식 페도라', 'https://images.unsplash.com/photo-1516216073819-82e7f0e5e5e5?w=600&q=80&fit=crop'),
('와인 버건디 페도라', 73000, '페도라', 4, '깊고 풍부한 와인 버건디 컬러의 페도라', 'https://images.unsplash.com/photo-1516216073819-82e7f0e5e5e5?w=600&q=80&fit=crop');

-- 스냅백 40개 ─────────────────────────────────────────────────────────────────
INSERT INTO hat (hat_name, hat_price, hat_category, hat_stock, hat_desc, hat_image) VALUES
('클래식 스냅백', 29000, '스냅백', 30, '언제나 인기 있는 클래식 스타일 스냅백', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80&fit=crop'),
('플랫 브림 스냅백', 33000, '스냅백', 20, '납작한 챙으로 힙합 감성을 완성하는 스냅백', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80&fit=crop'),
('빈티지 로고 스냅백', 42000, '스냅백', 12, '빈티지 로고 자수가 돋보이는 레트로 스냅백', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80&fit=crop'),
('레트로 스냅백', 38000, '스냅백', 0, '80~90년대 감성이 담긴 레트로 스타일 스냅백', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80&fit=crop'),
('컬러블록 스냅백', 35000, '스냅백', 18, '대담한 컬러블록 디자인의 스트리트 스냅백', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80&fit=crop'),
('그라디언트 스냅백', 40000, '스냅백', 8, '아름다운 그라디언트 컬러의 트렌디 스냅백', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80&fit=crop'),
('하이크라운 스냅백', 45000, '스냅백', 14, '높은 크라운으로 존재감을 높인 스냅백', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80&fit=crop'),
('로우크라운 스냅백', 32000, '스냅백', 25, '낮고 깔끔한 크라운의 캐주얼 스냅백', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=600&q=80&fit=crop'),

('6패널 스냅백', 28000, '스냅백', 35, '정통 6패널 구조의 클래식 스냅백', 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=600&q=80&fit=crop'),
('5패널 스냅백', 30000, '스냅백', 22, '5패널 구조로 독특한 실루엣의 스냅백', 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=600&q=80&fit=crop'),
('자수 패치 스냅백', 48000, '스냅백', 0, '정교한 자수와 패치가 어우러진 스냅백', 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=600&q=80&fit=crop'),
('고무 로고 스냅백', 36000, '스냅백', 17, '고무 소재 로고 패치가 포인트인 스냅백', 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=600&q=80&fit=crop'),
('스웨이드 스냅백', 55000, '스냅백', 7, '고급스러운 스웨이드 소재의 프리미엄 스냅백', 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=600&q=80&fit=crop'),
('코듀로이 스냅백', 47000, '스냅백', 9, '빈티지 감성의 코듀로이 소재 스냅백', 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=600&q=80&fit=crop'),
('캔버스 스냅백', 26000, '스냅백', 40, '튼튼한 캔버스 소재의 기본 스냅백', 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=600&q=80&fit=crop'),
('나일론 스냅백', 34000, '스냅백', 15, '가볍고 방수 기능의 나일론 소재 스냅백', 'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=600&q=80&fit=crop'),

('메쉬 패널 스냅백', 31000, '스냅백', 28, '통기성 메쉬 패널로 시원한 착용감의 스냅백', 'https://images.unsplash.com/photo-1581803579035-5e8a7e8e8e8e?w=600&q=80&fit=crop'),
('울 블렌드 스냅백', 52000, '스냅백', 6, '울 혼방 소재로 따뜻한 가을·겨울용 스냅백', 'https://images.unsplash.com/photo-1581803579035-5e8a7e8e8e8e?w=600&q=80&fit=crop'),
('데님 스냅백', 39000, '스냅백', 13, '데님 소재로 캐주얼하고 트렌디한 스냅백', 'https://images.unsplash.com/photo-1581803579035-5e8a7e8e8e8e?w=600&q=80&fit=crop'),
('카모 스냅백', 37000, '스냅백', 0, '밀리터리 감성의 카모플라주 패턴 스냅백', 'https://images.unsplash.com/photo-1581803579035-5e8a7e8e8e8e?w=600&q=80&fit=crop'),
('타이다이 스냅백', 41000, '스냅백', 10, '개성 있는 타이다이 패턴의 유니크한 스냅백', 'https://images.unsplash.com/photo-1581803579035-5e8a7e8e8e8e?w=600&q=80&fit=crop'),
('체크 스냅백', 35000, '스냅백', 21, '클래식한 체크 패턴의 스타일리시한 스냅백', 'https://images.unsplash.com/photo-1581803579035-5e8a7e8e8e8e?w=600&q=80&fit=crop'),
('스트라이프 스냅백', 33000, '스냅백', 16, '깔끔한 스트라이프 패턴의 스포티 스냅백', 'https://images.unsplash.com/photo-1581803579035-5e8a7e8e8e8e?w=600&q=80&fit=crop'),
('투톤 스냅백', 36000, '스냅백', 19, '대비되는 두 컬러로 포인트를 주는 스냅백', 'https://images.unsplash.com/photo-1581803579035-5e8a7e8e8e8e?w=600&q=80&fit=crop'),

('모노크롬 스냅백', 31000, '스냅백', 32, '단색 톤온톤 스타일의 세련된 스냅백', 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600&q=80&fit=crop'),
('네온 스냅백', 38000, '스냅백', 0, '눈에 띄는 네온 컬러의 펀한 스냅백', 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600&q=80&fit=crop'),
('어스 톤 스냅백', 34000, '스냅백', 24, '자연에서 온 어스 톤 컬러의 내추럴 스냅백', 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600&q=80&fit=crop'),
('파스텔 스냅백', 32000, '스냅백', 15, '부드러운 파스텔 컬러의 사랑스러운 스냅백', 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600&q=80&fit=crop'),
('리사이클 스냅백', 49000, '스냅백', 8, '재활용 소재로 만든 친환경 스냅백', 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600&q=80&fit=crop'),
('오가닉 스냅백', 46000, '스냅백', 11, '유기농 코튼으로 제작된 에코 프렌들리 스냅백', 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600&q=80&fit=crop'),
('올 오버 스냅백', 44000, '스냅백', 6, '전면 패턴이 가득 찬 올오버 프린트 스냅백', 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600&q=80&fit=crop'),
('그래픽 스냅백', 42000, '스냅백', 13, '개성 있는 그래픽 아트워크의 스냅백', 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=600&q=80&fit=crop'),

('금속 클립 스냅백', 58000, '스냅백', 4, '금속 스냅 클립 디테일의 프리미엄 스냅백', 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=600&q=80&fit=crop'),
('제한판 콜라보 스냅백', 79000, '스냅백', 2, '아티스트 콜라보레이션의 한정판 스냅백', 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=600&q=80&fit=crop'),
('스트리트 시그니처 스냅백', 65000, '스냅백', 5, '스트리트 씬을 대표하는 시그니처 스냅백', 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=600&q=80&fit=crop'),
('팀 로고 스냅백', 35000, '스냅백', 30, '팀 스피릿을 담은 로고 스냅백', 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=600&q=80&fit=crop'),
('어반 힙합 스냅백', 47000, '스냅백', 0, '힙합 컬처에서 영감 받은 어반 스냅백', 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=600&q=80&fit=crop'),
('오버사이즈 스냅백', 43000, '스냅백', 9, '넉넉한 오버사이즈 핏의 루즈한 스냅백', 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=600&q=80&fit=crop'),
('솔리드 화이트 스냅백', 24000, '스냅백', 45, '깔끔한 화이트 솔리드 컬러의 기본 스냅백', 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=600&q=80&fit=crop'),
('솔리드 블랙 스냅백', 24000, '스냅백', 50, '언제나 무난한 블랙 솔리드 컬러 스냅백', 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=600&q=80&fit=crop');
