#!/usr/bin/env python3
# ralph 루프 스모크 게이트 — 의존성 없음(표준 라이브러리만).
# Generator가 같은 폴더에 calc.py(add 함수)를 만들면 통과한다.
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

try:
    from calc import add
except Exception as e:  # 아직 생성 안 됨/임포트 실패
    print(f"GATE FAIL: calc import 실패: {e}")
    sys.exit(1)

assert add(2, 3) == 5, "add(2,3) != 5"
assert add(-1, 1) == 0, "add(-1,1) != 0"
assert add(0, 0) == 0, "add(0,0) != 0"
print("GATE OK")
