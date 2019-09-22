select
  a.person_id as person_id,
  ifnull(b.p, 0) as x_occurrence,
  ifnull(c.p, 0) as x_psychiatric,
  (ifnull(b.p, 0) - ifnull(c.p, 0)) as xn_psychiatric,
  if(c.p > 0, 1, 0) as is_psychiatric,
  ifnull(d.p, 0) as x_visit,
  ifnull(e.p, 0) as x_procedure,
  cast(ceiling(ifnull(f.p1, 0)) as int64) as avg_occu_duration,
  ifnull(f.p2, 0) as min_occu_duration,
  ifnull(f.p3, 0) as max_occu_duration,
  if(g.p > 0, 1, 0) as is_death,
  ifnull(h.p, 0) as x_age,
  if(a.gender_concept_id = 8507, 1, 0) as is_sex_male,
  if(a.gender_concept_id = 8532, 1, 0) as is_sex_female,
  ifnull(i.p, 0) as x_mellitus,
  ifnull(j.p, 0) as x_hypertension,
  ifnull(k.p, 0) as x_alz,
  ifnull(l.p, 0) as x_critical,
  if(l.p > 0, 1, 0) as is_critical,
  ifnull(date_diff(l.d2, l.d1, DAY), 0) as x_crit_duration,
  ifnull(n.p, 0) as x_crit0_psychiatric,
  ifnull(m.p, 0) as x_crit1_psychiatric,
  ifnull(o.p, 0) as x_crit2_psychiatric,
  n.d0 as d0,
  m.d1 as d1,
  o.d2 as d2
from `chrome-coast-249308.korea_datathon_dataset.person` a
  left join (
    select person_id, count(condition_occurrence_id) as p from `chrome-coast-249308.korea_datathon_dataset.condition_occurrence` group by person_id
  ) b on a.person_id = b.person_id
  left join (
    select person_id, count(condition_occurrence_id) as p from `korea-datathon-2019.team13_2.psychiatric_occurrence` group by person_id
  ) c on a.person_id = c.person_id
  left join (
    select person_id, count(visit_occurrence_id) as p from `chrome-coast-249308.korea_datathon_dataset.visit_occurrence` group by person_id
  ) d on a.person_id = d.person_id
  left join (
    select person_id, count(procedure_occurrence_id) as p from `chrome-coast-249308.korea_datathon_dataset.procedure_occurrence` group by person_id
  ) e on a.person_id = e.person_id
  left join (
    select person_id, avg(duration) as p1, min(duration) as p2, max(duration) as p3 from ( select person_id, date_diff(condition_end_date, condition_start_date, DAY) as duration
      from `chrome-coast-249308.korea_datathon_dataset.condition_occurrence`) group by person_id
  ) f on a.person_id = f.person_id
  left join (
    select person_id, count(person_id) as p from `chrome-coast-249308.korea_datathon_dataset.death` group by person_id
  ) g on a.person_id = g.person_id
  left join (
    select person_id, datetime_diff( (select max(birth_datetime) as now from `chrome-coast-249308.korea_datathon_dataset.person`), birth_datetime, YEAR ) as p from `chrome-coast-249308.korea_datathon_dataset.person`
  ) h on a.person_id = h.person_id
  left join (
    select person_id, count(condition_occurrence_id) as p from `chrome-coast-249308.korea_datathon_dataset.condition_occurrence` where condition_concept_id in (4008576, 443732, 443412, 201826, 201254, 4193704) group by person_id
  ) i on a.person_id = i.person_id
  left join (
    select person_id, count(condition_occurrence_id) as p from `chrome-coast-249308.korea_datathon_dataset.condition_occurrence` where condition_concept_id in (317895, 320128) group by person_id
  ) j on a.person_id = j.person_id
  left join (
    select person_id, count(condition_occurrence_id) as p from `chrome-coast-249308.korea_datathon_dataset.condition_occurrence` where condition_concept_id in (378419, 4220313, 4218017, 4278830, 4277444) group by person_id
  ) k on a.person_id = k.person_id
  left join (
    select person_id, count(procedure_occurrence_id) as p, min(procedure_date) as d1, max(procedure_date) as d2 from `korea-datathon-2019.team13_2.critical_occurrence` group by person_id
  ) l on a.person_id = l.person_id
  left join (
    select n_a.person_id as person_id, n_a.p as p, n_a.d as d0, n_b.p as d1, null as d2 from (
      select person_id, count(condition_occurrence_id) as p, min(condition_start_date) as d from `korea-datathon-2019.team13_2.psychiatric_occurrence` group by person_id
    ) n_a, (
      select person_id, min(procedure_date) as p from `korea-datathon-2019.team13_2.critical_occurrence` group by person_id
    ) n_b where n_a.person_id = n_b.person_id and n_a.d < n_b.p
  ) n on a.person_id = n.person_id
  left join (
    select m_a.person_id as person_id, m_a.p as p, m_a.d as d0, m_b.p as d1, null as d2 from (
      select person_id, count(condition_occurrence_id) as p, min(condition_start_date) as d from `korea-datathon-2019.team13_2.psychiatric_occurrence` group by person_id
    ) m_a, (
      select person_id, max(procedure_date) as p from `korea-datathon-2019.team13_2.critical_occurrence` group by person_id
    ) m_b where m_a.person_id = m_b.person_id and m_a.d > m_b.p
  ) m on a.person_id = m.person_id
  left join (
    select o_a.person_id as person_id, o_a.p as p, o_a.d as d0, o_b.p1 as d1, o_b.p2 as d2 from (
      select person_id, count(condition_occurrence_id) as p, min(condition_start_date) as d from `korea-datathon-2019.team13_2.psychiatric_occurrence` group by person_id
    ) o_a, (
      select person_id, min(procedure_date) as p1, max(procedure_date) as p2 from `korea-datathon-2019.team13_2.critical_occurrence` group by person_id
    ) o_b where o_a.person_id = o_b.person_id and o_a.d >= o_b.p1 and o_a.d <= o_b.p2
  ) o on a.person_id = o.person_id
