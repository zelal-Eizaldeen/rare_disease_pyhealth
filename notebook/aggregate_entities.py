import json

# Load match_2 and match_3 results
with open("/projects/illinois/eng/cs/jimeng/zelalae2/scratch/RDMA/zilal_contribution/output_checkpoints/testing_step3_match_rd_1000_context_output.json") as f:
    match_2 = json.load(f)["results"]

with open("/projects/illinois/eng/cs/jimeng/zelalae2/scratch/RDMA/zilal_contribution/output_checkpoints/testing_step3_match_rd_1000_context_output.json") as f:
    match_3 = json.load(f)["results"]

# Load annotator-reviewed results
with open("/projects/illinois/eng/cs/jimeng/zelalae2/scratch/med_students/high_agreement_annotations.json") as f:
    annotations = json.load(f)["corrected_annotations"]

# 1. Combine match_2 and match_3 into one dictionary
aggregated_matches = {**match_2}  # start with match_2
for doc_id, data in match_3.items():
    if doc_id in aggregated_matches:
        # Merge matched_diseases
        existing_entities = {
            (d["entity"], d["orpha_id"]) for d in aggregated_matches[doc_id]["matched_diseases"]
        }
        new_entities = [
            d for d in data["matched_diseases"]
            if (d["entity"], d["orpha_id"]) not in existing_entities
        ]
        aggregated_matches[doc_id]["matched_diseases"].extend(new_entities)
    else:
        aggregated_matches[doc_id] = data

# 2. Build set of (document_id, entity) from annotator annotations
excluded_entities = {
    (ann["document_id"], ann["entity"].lower())
    for ann in annotations
}

# 3. Filter out matched diseases that were annotated already
filtered_matches = {}
for doc_id, data in aggregated_matches.items():
    filtered_diseases = [
        d for d in data["matched_diseases"]
        if (doc_id, d["entity"].lower()) not in excluded_entities
    ]
    if filtered_diseases:
        new_data = dict(data)
        new_data["matched_diseases"] = filtered_diseases
        filtered_matches[doc_id] = new_data

# 4. Save final filtered output
final_output = {
    "metadata": {"merged": True},
    "results": filtered_matches
}

with open("/projects/illinois/eng/cs/jimeng/zelalae2/scratch/med_students/excluded_matches.json", "w") as f:
    json.dump(final_output, f, indent=2)

print("✅ Aggregation and filtering complete. Output saved as filtered_matches.json")
