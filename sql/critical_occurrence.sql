select * from `chrome-coast-249308.korea_datathon_dataset.procedure_occurrence` where procedure_concept_id in (
  select concept_id from (SELECT * FROM `chrome-coast-249308.korea_datathon_dataset.concept` where lower(concept_name) like '%tracheostomy%') a
  inner join ( select procedure_concept_id from `chrome-coast-249308.korea_datathon_dataset.procedure_occurrence` group by procedure_concept_id) b
  on a.concept_id = b.procedure_concept_id
)
