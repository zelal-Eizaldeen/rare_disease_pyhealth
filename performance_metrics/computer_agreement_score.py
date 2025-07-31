import pandas as pd
import json
from sklearn.metrics import cohen_kappa_score
from collections import defaultdict
from itertools import combinations

# Load JSON files
file_paths = [
   "/projects/illinois/eng/cs/jimeng/zelalae2/scratch/med_students/finished_Jeffrey_rare_disease_reviews_2.json",
   "/projects/illinois/eng/cs/jimeng/zelalae2/scratch/med_students/Jennifer_finished_rare_disease_reviews.json",
   "/projects/illinois/eng/cs/jimeng/zelalae2/scratch/med_students/lauren_rare_disease_reviews.json",
   "/projects/illinois/eng/cs/jimeng/zelalae2/scratch/med_students/Mya_rare_disease_reviews.json"
]

annotations_by_user = {}

for path in file_paths:
    with open(path, "r") as f:
        data = json.load(f)
        user_annotations = defaultdict(dict)
        for ann in data["corrected_annotations"]:
            key = (ann["document_id"], ann["entity"])
            label = ann["is_rare_disease"]
            user_annotations[key] = label
        annotations_by_user[path] = user_annotations

# Gather all unique annotation keys
all_keys = set()
for user_data in annotations_by_user.values():
    all_keys.update(user_data.keys())

# Create binary annotation matrix
user_labels = {}
for user, ann_dict in annotations_by_user.items():
    labels = []
    for key in sorted(all_keys):
        labels.append(ann_dict.get(key, None))  # Use None for missing
    user_labels[user] = labels

# Compute pairwise Cohen's Kappa scores
users = list(user_labels.keys())
results = []
for u1, u2 in combinations(users, 2):
    l1 = user_labels[u1]
    l2 = user_labels[u2]
    valid_indices = [i for i, (a, b) in enumerate(zip(l1, l2)) if a is not None and b is not None]
    if valid_indices:
        filtered_l1 = [l1[i] for i in valid_indices]
        filtered_l2 = [l2[i] for i in valid_indices]
        kappa = cohen_kappa_score(filtered_l1, filtered_l2)
        results.append((u1, u2, kappa))

agreement_df = pd.DataFrame(results, columns=["Annotator_1", "Annotator_2", "Cohen_Kappa"])


'''
Extract the highest ones
'''
# Set a threshold for "high agreement" (Cohen's kappa > 0.6 is often considered moderate to substantial agreement)
high_agreement_threshold = 0.6
high_agreement_pairs = [(u1, u2) for u1, u2, kappa in results if kappa > high_agreement_threshold]

# Find annotations where all annotators agree (on is_rare_disease and are not None)
# First, transpose the annotation matrix
all_keys_sorted = sorted(all_keys)
annotations_matrix = {key: [] for key in all_keys_sorted}
for user in users:
    for i, key in enumerate(all_keys_sorted):
        annotations_matrix[key].append(user_labels[user][i])

# Keep only the ones where all non-None values are equal
high_agreement_annotations = {
    key: values for key, values in annotations_matrix.items()
    if None not in values and len(set(values)) == 1
}

# Format for display
high_agreement_formatted = [
    {"document_id": key[0], "entity": key[1], "is_rare_disease": values[0]}
    for key, values in high_agreement_annotations.items()
]

high_agreement_df = pd.DataFrame(high_agreement_formatted)
print(high_agreement_df)
