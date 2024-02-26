ALTER TABLE example_table modify column id INT AUTO_INCREMENT;
-- (1) 문자형 데이터를 숫자형 필터링에 사용
INSERT INTO example_table (id, small_integer) VALUES
  (null, 10),
  (null, 20),
  (null, 30),
  (null, 40),
  (null, 50);
SELECT id, small_integer FROM example_table WHERE small_integer > 25;
SELECT id, small_integer FROM example_table WHERE small_integer > '25';  -- 괜찮음
-- (2) 숫자형 데이터를 문자열 필터링에 사용
INSERT INTO example_table (id, variable_length_string) VALUES
  (null, '10'),
  (null, '20'),
  (null, '30'),
  (null, '40'),
  (null, '50');
SELECT id, variable_length_string FROM example_table WHERE variable_length_string > 25;  -- 타입캐스팅 오버헤드 발생
SELECT id, variable_length_string FROM example_table WHERE variable_length_string > '25'; -- 문자열 대소 비교에서도 시스템 내부적 타입캐스팅 발생
-- (3) 숫자로 타입캐스팅이 불가능한 데이터를 숫자로 필터링
INSERT INTO example_table (id, variable_length_string) VALUES
  (null, 'Sixty'),
  (null, 'Seventy'),
  (null, 'Eighty');
INSERT INTO example_table (id, variable_length_string) VALUES
  (null, '90'),
  (null, '100');
SELECT id, variable_length_string FROM example_table WHERE variable_length_string > 60;  -- 의도치 않은 데이터 제외 : Truncated incorrect DOUBLE value: 'Three'
SELECT id, variable_length_string FROM example_table WHERE variable_length_string > 'Seventy'; -- 데이터 제외되지 않지만 일반적으로 의도치 않는 동작
-- => 결론 : 숫자는 반드시 숫자 타입으로 다루자.