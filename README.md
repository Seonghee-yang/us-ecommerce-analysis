# E-Commerce 고객 행동 분석 : RFM 세분화 기반 매출 성장 전략

> **매출을 유지하기 이해 반드시 관리해야 할 고객은 누구이며, 한정된 CRM 자원을 어디에 우선 배분해야 하는가?**

US Superstore 구매 데이터를 기반으로 **매출 성장 구조와 고객 행동을 분석하고, RFM 기반 세분화와 고객군별 CRM 전략을 도출**한 프로젝트입니다.

📄 분석 과정 전체(시각화 포함)는 포트폴리오 PDF 에 정리되어 있습니다. 이 문서는 프로젝트 요약이며, 코드와 설계 과정은 notebooks/에서 확인하실 수 있습니다.

## 🎯 Analysis Objective
| Question | Analysis |
| --- | --- |
| **Q1. 매출을 유지하기 위해 반드시 관리해야 할 고객은 누구인가?** | Revenue Structure + Lorenz Curve |
| **Q2. 신규 고객은 언제 가장 많이 이탈하는가?** | Cohort Analysis |
| **Q3. 한정된 CRM 자원을 고객군별로 어떻게 배분할 것인가?** | RFM + Statistical Validation |

## 📌Project Overview
2020년 US Superstore 구매 로그를 기반으로 **매출이 어디에서 발생하고, 고객이 어떻게 구매하며, 어떤 고객을 우선 관리해야 하는지**를 단계적으로 분석했습니다.

> 매출 구조 → 고객 리텐션 → 고객 세분화 → 행동 차이 검증 → CRM 전략

#### 🗂️ Project Information
| 항목 | 내용 |
|---|---|
| 기간 | 2026.08 |
| Data | US Superstore Orders 2020 |
| Role | 개인 프로젝트 |
| Tools | Python, SQL (MySQL), Tableau |
| Methods | SQL, RFM, Lorenz Curve, Cohort Analysis, Mann-Whitney U Test |

## 📊 Data
- **```Records```** : 주문/상품 단위 거래 데이터
- **```Customer Stats```** : 고객 단위 집계 데이터
- **Structure** : Records → Customer Stats (1:N)

고객 단위 분석을 위해 주문 데이터를 고객 기준으로 집계하여 Recency, Frequency, Monetary를 산출했습니다.

## 🚨 Problem
**1. 매출 성장 구조 확인 필요**

2020년 매출이 지속 성장했지만, 이 성장이 고객 1인당 소비 증가가 아니라 활성 고객 수 증가에 의존한다면 신규 유입이 둔화되는 순간 성장 동력을 잃을 수 있습니다. 

**2. 전체 고객을 동일하게 관리하기 어려움**

기존 세그먼트/카테고리 단위 분석만으로는 동일 집단 내 
- 핵심 매출 고객
- 성장 가능 고객
- 이탈 위험 고객

을 구분하기 어려웠습니다.

**3. 제한된 CRM 자원 배분 우선순위 필요**

모든 고객에게 동일한 CRM 자원을 투입하기보다 고객 가치와 이탈 가능성을 고려하여 관리 우선순위를 설정할 필요가 있었습니다.


## 💡 Key Findings
**01. 매출 성장은 활성 고객 수 증가에 의존**

PU 증가 흐름이 매출 증가와 유사하게 나타난 반면, ARPPU는 연중 비교적 안정적으로 유지되었습니다.

→ 2020년 매출 성장은 **유입 의존형 성장 구조**로 해석하였습니다.

→ 따라서, 신규 유입뿐 아니라 기존 고객의 재구매를 높이는 전략이 필요하다고 판단했습니다.


**02. 매출은 소수 고객에게 집중**

Lorenz Curve 분석 결과, 상위 20% 고객이 매출의 60.3%를 차지하는 파레토 구조입니다.

→ 모든 고객을 동일하게 관리하기보다 고객별 가치 차이를 고려한 관리가 필요했습니다.

**03. 신규 고객의 초기 재구매가 주요 이탈 구간**

Cohort Analysis 결과, 대부분의 코호트에서 첫 구매 후 1개월 차 리텐션이 **10~15% 수준으로 급락**했습니다.

→ 첫 구매 이후 2차 구매를 유도하는 초기 CRM 전략이 중요하다고 판단했습니다.

> Data Limitation: 본 데이터는 2020년 한 해의 구매 내역만 포함하고 있어, 해당 연도에 처음 구매한 고객이 실제 신규 고객인지 이전부터 거래해온 고객인지 구분할 수 없습니다. 따라서 본 분석에서의 신규 고객과 1개월 차 이탈은 2020년 관측 기간 내 첫 구매를 기준으로 한 근사치로 해석했습니다.

**04. VIP 전환의 핵심 요인은 "구매 빈도"**

Potential Loyal과 VIP의 R/F/M 차이를 비교한 결과 세 지표 모두 통계적으로 유의했으며, Frequency의 Effect Size가 0.499로 가장 크게 나타났습니다.

| Metric | Potential Loyal | VIP | Difference |
|---|---:|---:|---:|
| Frequency | 2.85회 | 4.06회 | **+1.21회** |
| Recency | 41.29일 | 22.66일 | **18.62일** |
| Monetary | $1,432 | $2,082 | **+$650.76** |

→ VIP 전환을 위해 객단가 증대보다 **구매 주기 단축(41일 → 20일대)하는 전략**에 우선순위를 둘 필요가 있다고 판단했습니다.


## 🔍 Analysis
### RFM Segmentation - 고객을 어떻게 구분할 것인가?
매출 집중도와 고객 리텐션 분석을 통해 고객별 가치와 구매 행동을 고려한 세분화가 필요하다고 판단했습니다.

이에 고객 단위 RFM 분석을 수행하고,, 고객의 실제 구매 분포와 구매 주기를 반영하여 **5점 척도 RFM Score**를 설계했습니다.

#### Customer Segments
| Segment | |
| --- | --- |
| VIP | 높은 구매 빈도와 구매 금액을 가진 핵심 고객군 |
| Potential Loyal | 반복 구매가 시작된 성장 가능 고객 |
| Lost VIP | 과거 구매 가치가 높았지만, 현재 활동이 감소한 고객 |
| Need Attention | 구매 빈도가 감소하기 시작해 추가 관리가 필요한 고객 |
| About to Sleep | 구매 활동이 둔화되어 이탈 가능성이 높아지는 고객 |
| New Customers | 최근 유입된 신규 고객, 첫 구매 이후 재구매가 필요한 고객 |
| Lost Customers / Hibernating | 장기간 구매 활동이 없는 고객 |


### Statistical Validation - VIP 전환을 만드는 행동은 무엇인가?
Potential Loyal과 VIP의 R/F/M 차이를 비교하여 **두 고객군의 행동 차이 중 어떤 지표가 상대적으로 큰지** 확인하고, CRM 전략에서 우선적으로 활용할 수 있는 지표를 탐색했습니다.

Mann-Whitney U Test와 Effect Size를 활용한 결과:
| Metric        | p-value | Effect Size (r) |
| ------------- | ------: | --------------: |
| **Frequency** | < 0.001 |       **0.499** |
| Recency       | < 0.001 |           0.420 |
| Monetary      | < 0.001 |           0.382 |

→ 세 지표 모두 통계적으로 유의했으며, Frequency의 Effect Size가 가장 크게 나타났습니다.

***Note***
- Potential Loyal과 VIP는 모두 R/F/M 기준을 활용해 정의된 세그먼트이기 때문에, **두 집단 간 R/F/M 차이의 통계적 유의성 자체를 독립적인 인과 증거로 해석할 수는 없습니다.**
- 본 검정은 세 지표 중 **상대적으로 어떤 행동 차이가 크게 나타나는지를 비교하고, CRM 전략의 우선 순위를 선정하기 위한 보조적 검증** 으로 활용했습니다.


## 📈 CRM Resource Allocation & Action Plan 
> 분석 결과를 바탕으로 고객군별 목적과 관리 우선순위를 구분했습니다.

| 고객군                    | 목적       | Key Action   |
| ---------------------- | -------- | ----------- |
| **Potential Loyal**    | VIP 성장   | 재구매 유도      |
| **VIP**                | 매출 유지    | 이탈 방지 / 로열티 강화 |
| **Lost VIP**           | 매출 회복    | 선별적 재활성화    |
| **Need Attention**     | 이탈 방어    | 구매 감소 시점 개입 |
| **New Customers**      | 초기 정착    | 2차 구매 유도    |
| **Lost Customers / Hibernating** | 저비용 재활성화 | 선별적 리타겟팅    |

## 📊 Tableau Dashboard
🔗 **[Tableau Public Dashboard]("https://public.tableau.com/app/profile/.55641854/vizzes")**

## 📁 Repository Structure
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
└── outputs/
    ├── revenue_trend.png
    ├── lorenz_curve.png
    ├── cohort_analysis.png
    ├── rfm_segments.png
    └── customer_strategy.png
```

## 🧠 What I Learned
고객을 나누는 것보다, 어디서부터 다르게 봐야 하는지가 더 중요하다는 것을 배웠습니다.

처음에는 이진 기준으로 고객을 분류했습니다. 하지만 적용 과정에서 경계값을 조금 넘은 고객과 훨씬 높은 고객이 같은 그룹으로 묶이는 문제가 있었습니다.

이 문제를 바탕으로 고객의 실제 행동 분포를 다시 확인하고, 이진 기준을 5점 척도로 재설계했습니다. 예를 들어 Recency는 단순히 하나의 기준값을 적용하지 않고, 전체 재구매 주기와 카테고리별 구매 특성을 함께 고려해 기준을 조정했습니다.

이 기준이 고객의 행동을 제대로 설명하고 있는가?를 다시 질문하는 과정이 중요하다는 것을 깨닫고,
고객을 "누가 중요한가?"에서 
누구에게, 어떤 행동을 유도해야 하는가?"로 질문을 확장할 수 있었습니다.

이번 프로젝트에서 분석 기준을 재설계하며, 데이터와 부딪히고 더 나은 기준을 만들어가는 과정이 중요하다는 것을 배웠습니다.



## ⚠️ Limitations
- 2020년 단일 연도 데이터이므로 "신규 고객"은 실제 고객 생애주기 기준 신규 고객이 아니라 관측 기간 내 첫 구매 고객으로 해석해야 합니다.
- 단일 연도 데이터의 한계로 Potential Loyal 고객이 이후 실제 VIP로 전환되었는지 종단적으로 검증하지 못했습니다.
- Potential Loyal과 VIP가 R/F/M 기준으로 정의되었기 때문에 R/F/M 차이의 유의성 자체는 세그먼트 정의와 독립적인 검증이라고 보기 어렵습니다.
- CRM Action Plan은 실제 캠페인 실험 결과가 아닌 분석 결과를 기반으로 제안한 전략입니다.
