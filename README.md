# E-Commerce 고객 행동 분석 : RFM 세분화 기반 매출 성장 전략

## 🎯 Analysis Objective
| Question | Analysis |
| --- | --- |
| **Q1. 매출을 유지하기 위해 반드시 관리해야 할 고객은 누구인가?** | Revenue Structure + Lorenz Curve |
| **Q2. 신규 고객은 언제 가장 많이 이탈하는가?** | Cohort Analysis |
| **Q3. 한정된 CRM 자원을 고객군별로 어떻게 배분할 것인가?** | RFM + Statistical Validation |

## 📌Project Overview
US Superstore 구매 로그를 기반으로 매출 성장 구조와 고객 행동을 분석하고, 데이터 분포와 구매 주기를 반영한 RFM 세분화를 통해 **고객군별 CRM 매출 성장 전략**을 도출한 프로젝트입니다.

Data Understanding → EDA(Revenue/PU/ARPPU) → Lorenz Curve → Cohort Analysis → RFM 세분화 → Customer Segmentation → CRM Priority & Action Plan

#### Project Information
- 기간 : 2026.04 ~ 2026.05
- Data : US Superstore Orders 2020
- Role : 개인 프로젝트(문제 정의, 데이터 마트 구축, EDA, RFM 설계, 통계 검정, CRM 전략 도출)
- Tools : Python, SQL (MySQL), Tableau
- Methods : SQL, RFM, Lorenz Curve, Cohort Analysis, Mann-Whitney U Test

### 📊 Data
- **```Records```** : 주문/상품 단위 거래 데이터
- **```Customer Stats```** : 고객 단위 집계 데이터
- **Structure** : Records → Customer Stats (1:N)

#### 🚨 Problem
- 2020년 매출은 지속 성장했지만, 이 성장이 고객 1인당 소비 증가가 아니라 활성 고객 수 증가에 의존한다면 신규 유입이 둔화되는 순간 성장 동력을 잃을 수 있음
- 기존 세그먼트/카테고리 단위 분석만으로는 동일 집단 내 우수 고객과 이탈 위험 고객을 구분하기 어려움
- 한정된 CRM 자원을 어떤 고객군에 우선 배분해야 하는지에 대한 데이터 기반 근거가 필요함

## 💡 Key Findings
01. 매출은 왜 증가했는가? - **매출 성장은 활성 고객 수 증가에 의존**
PU 증가가 매출 증가 흐름과 유사한 반면 ARPPU는 연중 비교적 안정적으로 유지됨

→ **유입 의존형 성장 구조**
→ 신규 유입이 둔화되는 순간 성장 동력을 잃는 리스크를 확인하고, 신규 유입뿐 아니라 기존 고객의 재구매를 높이는 전략이 필요


02. **매출은 소수 고객에게 집중**
상위 20% 고객이 매출의 60.3%를 차지하는 파레토 구조 

→ 모든 고객을 동일하게 관리하기보다 고객별 가치 차이를 고려한 관리가 필요

03. 신규 유입 중심 성장이 지속 가능한가? - **신규 고객의 초기 이탈이 주요 누수 구간**
대부분의 코호트에서 첫 구매 후 1개월 차 리텐션이
**10~15% 수준으로 급락**

→ 첫 구매 이후 재구매를 유도하는 전략이 필요

> 데이터 한계: 이 데이터셋은 2020년 한 해의 구매 내역만 포함하고 있어, "신규 고객"이 실제로 그 해 처음 구매한 고객인지 이전부터 거래해온 고객인지 구분할 수 없습니다. 따라서 "1개월 차 이탈"은 고객의 전체 생애주기 기준이 아니라 2020년 관측 기간 내 첫 구매 기준의 근사치로 해석해야 합니다.

04. **VIP 전환의 핵심 레버는 "구매 빈도"**
Potential Loyal과 VIP 간 R/F/M 차이를 검정한 결과 Frequency의 Effect Size(0.499)가 Monetary(0.382)보다 크게 나타남
→ VIP 전환을 위해 객단가 증대보다 구매 주기 단축(41일 → 20일대)에 집중해야 함.


## 🔍 Analysis
#### RFM Segmentation - 고객을 어떻게 구분할 것인가?
매출 구조와 리텐션 분석을 통해 고객별 가치와 행동 차이를 고려한 관리가 필요하다고 판단했습니다.
이에 고객 단위 RFM 분석으로 확장하여, 고객의 실제 구매 분포와 구매 주기를 반영한 5점 척도 RFM을 설계했습니다.

Segment	의미
| Segment | |
| --- | --- |
| VIP | 높은 구매 빈도와 구매 금액을 가진 핵심 고객군 |
| Potential Loyal | 반복 구매가 시작된 성장 가능 고객 |
| Lost VIP | 과거 구매 가치가 높았지만, 현재 활동이 감소한 고객 |
| Need Attention | 구매 빈도가 감소하기 시작한 이탈 위험 고객, 구매 활동은 존재하지만 추가 관리가 필요한 고객 |
| About to Sleep | 구매 활동이 둔화되어 이탈 가능성이 높아지는 고객 |
| New Customers | 최근 유입된 신규 고객, 첫 구매 이후 재구매가 필요한 고객 |
| Lost Customers / Hibernating | 장기간 구매 활동이 없는 고객 |


#### Statistical Validation - Potential Loyal과 VIP의 차이를 만드는 행동은 무엇인가?

Potential Loyal과 VIP의 R/F/M 차이를 비교하여 두 고객군의 행동 차이를 확인하고, CRM 전략에서 우선적으로 활용할 수 있는 지표를 탐색함.


| Metric        | p-value | Effect Size (r) |
| ------------- | ------: | --------------: |
| **Frequency** | < 0.001 |       **0.499** |
| Recency       | < 0.001 |           0.420 |
| Monetary      | < 0.001 |           0.382 |
- 세 지표 모두 통계적으로 유의했으며, 그 중 Frequency의 Effect size가 가장 큼

|           | Potential Loyal |    VIP | Difference |
| --------- | --------------: | -----: | ---------: |
| Frequency | 2.85회 | 4.06회 | **+1.21회** |
| Recency   | 41.29일 | 22.66일 | **18.62일** |
| Monetary  | $1,432 | $2,082 |   +$650.76 |


*두 세그먼트 자체가 R/F/M 값을 기준으로 정의되었기 때문에 "차이가 존재하는가"는 두 그룹 간 차이의 통계적 유의성 자체는 검정 이전부터 예정된 결과에 가깝습니다. 본 검정은 세 지표 중 어떤 행동 차이가 상대적으로 큰지 비교하고, CRM 레버를 선정하기 위한 목적으로 활용했습니다


### 📈 CRM Resource Allocation & Action Plan 
> 고객군별 자원을 어떻게 배분할 것인가?

| 고객군                    | 목적       | 주요 Action   |
| ---------------------- | -------- | ----------- |
| **Potential Loyal**    | VIP 성장   | 재구매 유도      |
| **VIP**                | 매출 유지    | 이탈 방지 / 로열티 |
| **Lost VIP**           | 매출 회복    | 선별적 재활성화    |
| **Need Attention**     | 이탈 방어    | 구매 감소 시점 개입 |
| **New Customers**      | 초기 정착    | 2차 구매 유도    |
| **Lost Customers / Hibernating** | 저비용 재활성화 | 선별적 리타겟팅    |



### Structure
```
├── data/                # US Superstore 원본 및 전처리 데이터 (customer_stats, records / 1:N 구조)
├── notebooks/           # EDA, Lorenz Curve, Cohort, RFM scoring, Mann-Whitney U Test
├── src/                 # RFM 점수화 및 세그먼트 분류 모듈
└── outputs/             # Tableau 대시보드 및 시각화 결과
```

us-ecommerce-rfm/
│
├── README.md
│
├── data/
│   └── README.md
│
├── sql/
│   ├── 01_data_preparation.sql
│   ├── 02_revenue_analysis.sql
│   └── 03_customer_analysis.sql
│
├── notebooks/
│   ├── 01_eda.ipynb
│   ├── 02_rfm_segmentation.ipynb
│
├── src/
│   └── rfm.py
│
└── outputs/
    ├── revenue_trend.png
    ├── lorenz_curve.png
    ├── cohort_analysis.png
    ├── rfm_segments.png
    └── customer_strategy.png


## 🧠 What I Learned

## 🛠 설계 의사결정 & 트러블슈팅

초기 R/F/M을 기준값 충족 여부로 0/1 이진 분류했을 때, 기준을 조금 넘긴 고객과 크게 벗어난 고객이 똑같이 분류되어 행동 차이를 반영하지 못한다는 한계를 확인했습니다. 아래는 재설계 과정에서 겪은 구체적인 시행착오입니다.

### 1) 이진 분류 → 5점 척도: "57일 vs 300일이 같은 취급을 받는 문제"
기준(예: 상위 50%)만 넘기면 전부 0점 처리되어, 기준을 하루 넘긴 고객과 몇 달 지난 고객이 구분되지 않았습니다. 사분위수·평균·중앙값을 함께 활용한 5단계 구간으로 재설계해, Lost VIP·Need Attention 같은 세부 집단까지 구분할 수 있게 됐습니다.

### 2) Recency 임계값: "감으로 정하기" → "근거가 교차하는 지점"
과거엔 "분포가 자연스럽게 꺾이는 지점"이라는 주관적 관찰로 57일을 택했습니다. 이번엔 전체 평균 재구매 주기(89일)와 카테고리별 특성(Technology 평균 115일)을 함께 반영해, 재구매 주기가 긴 카테고리 고객이 이탈 위험으로 오분류되지 않도록 상한을 120일로 설정했습니다.

## 🛠 설계 의사결정 & 트러블슈팅

초기 R/F/M을 기준값 충족 여부로 0/1 이진 분류했을 때, 기준을 조금 넘긴 고객과 크게 벗어난 고객이 똑같이 분류되어 행동 차이를 반영하지 못한다는 한계를 확인했습니다. 아래는 재설계 과정에서 겪은 구체적인 시행착오입니다.

### 1) 이진 분류 → 5점 척도: "57일 vs 300일이 같은 취급을 받는 문제"
기준(예: 상위 50%)만 넘기면 전부 0점 처리되어, 기준을 하루 넘긴 고객과 몇 달 지난 고객이 구분되지 않았습니다. 사분위수·평균·중앙값을 함께 활용한 5단계 구간으로 재설계해, Lost VIP·Need Attention 같은 세부 집단까지 구분할 수 있게 됐습니다.

### 2) Recency 임계값: "감으로 정하기" → "근거가 교차하는 지점"
과거엔 "분포가 자연스럽게 꺾이는 지점"이라는 주관적 관찰로 57일을 택했습니다. 이번엔 전체 평균 재구매 주기(89일)와 카테고리별 특성(Technology 평균 115일)을 함께 반영해, 재구매 주기가 긴 카테고리 고객이 이탈 위험으로 오분류되지 않도록 상한을 120일로 설정했습니다.

## ⚠️ Limitations
- 2020년 단일 연도 데이터이므로 "신규 고객"은 실제 고객 생애주기 기준 신규 고객이 아니라 관측 기간 내 첫 구매 고객으로 해석해야 합니다.
- Potential Loyal이 실제로 VIP로 전환되는지는 종단 데이터가 없어 직접 검증하지 못했습니다.
- Potential Loyal과 VIP가 R/F/M 기준으로 정의되었기 때문에 R/F/M 차이의 유의성 자체는 세그먼트 정의와 독립적인 검증이라고 보기 어렵습니다.
- CRM Action Plan은 실제 캠페인 실험 결과가 아닌 분석 결과를 기반으로 제안한 전략입니다.
