import json
import glob

# Step 1: List your annotator files
annotator_files = [
    "/projects/illinois/eng/cs/jimeng/zelalae2/scratch/med_students/finished_Jeffrey_rare_disease_reviews_2.json",
    "/projects/illinois/eng/cs/jimeng/zelalae2/scratch/med_students/Jennifer_finished_rare_disease_reviews.json",
    "/projects/illinois/eng/cs/jimeng/zelalae2/scratch/med_students/lauren_rare_disease_reviews.json",
    "/projects/illinois/eng/cs/jimeng/zelalae2/scratch/med_students/Mya_rare_disease_reviews.json"
]

# Step 2: Load and combine corrected_annotations
all_annotations = []
for filename in annotator_files:
    with open(filename, "r") as f:
        data = json.load(f)
        all_annotations.extend(data.get("corrected_annotations", []))

# Step 3: Save combined annotations to new file
combined = {
    "metadata": {
        "annotators_combined": len(annotator_files),
        "total_annotations": len(all_annotations)
    },
    "corrected_annotations": all_annotations
}

with open("/projects/illinois/eng/cs/jimeng/zelalae2/scratch/med_students/combined_annotators.json", "w") as f:
    json.dump(combined, f, indent=2)

print("✅ Combined all annotator files into combined_annotators.json")
