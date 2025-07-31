import sys

import json, math, pathlib
from datetime import datetime

sys.path.append('/projects/illinois/eng/cs/jimeng/zelalae2/scratch/PyHealth')

from pyhealth.datasets import MIMIC4NoteDataset

def timestamp_print(message: str) -> None:
    """Print message with timestamp."""
    print(f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - {message}")
# Select task
task_type = sys.argv[1]  # either "rare_disease" or "phenotype"

# Set table and output file based on task
if task_type == "rare_disease":
    table = "discharge"
    text_column = "discharge/text"
    # output_pickle = "/u/zelalae2/scratch/mimic4_note/sampling/patient_notes.pkl"
    output_json_prefix = "rd_patients_job"
    input_dir = pathlib.Path("/projects/illinois/eng/cs/jimeng/zelalae2/scratch/job_inputs")
elif task_type == "phenotype":
    table = "discharge"
    text_column = "discharge/text"
    # table = "radiology"
    # text_column = "radiology/text"
    # output_pickle = "/u/zelalae2/scratch/mimic4_note/sampling/patient_notes.pkl"
    output_json_prefix = "pho_patients_job"
    input_dir = pathlib.Path("/projects/illinois/eng/cs/jimeng/zelalae2/scratch/job_inputs")
else:
    raise ValueError("Invalid task_type. Must be 'rare_disease' or 'phenotype'.")

note_root = "/projects/illinois/eng/cs/jimeng/zelalae2/scratch/mimic4_note/physionet.org/files/mimic-iv-note/2.2/"
dataset = MIMIC4NoteDataset(root=note_root, tables=[table])
note_df = dataset.global_event_df.collect().to_pandas()

# Group and filter long notes
patient_notes = note_df.groupby("patient_id")[text_column].apply(lambda texts: "\n\n".join(texts))

# # Only include long notes (≥ 500 characters)
filtered_notes = patient_notes[patient_notes.str.len() > 500]
samples_patient_notes_1000 = filtered_notes.sample(n=1000, random_state=42)


print(f"type of sample_notes is {type(samples_patient_notes_1000)}")
# sample_id_path = "/u/zelalae2/scratch/mimic4_note/sampling/sampled_ids.json" 
# # rd_sample_notes_output_json = "/u/zelalae2/scratch/mimic4_note/sampling/patient_notes_input.json"
rd_sample_notes_output_json = "/projects/illinois/eng/cs/jimeng/zelalae2/scratch/mimic4_note/sampling/input_patient_notes_1000.json"



#Construct input dict
input_dict = {}
for patient_id, text in samples_patient_notes_1000.items():
    input_dict[str(patient_id)] = {
        "clinical_text": text,
        "patient_id": str(patient_id),  # Optional, consistent naming
        "hadm_id": "",  # Not available from note_df unless you merge with ADMISSIONS
        "category": "",  # Could be filled if grouping by category instead
        "chartdate": ""  # Not meaningful at patient-level unless aggregated
    }


# Save to input JSON
pathlib.Path(rd_sample_notes_output_json).parent.mkdir(parents=True, exist_ok=True)
with open(rd_sample_notes_output_json, "w") as f:
    json.dump(input_dict, f, indent=2)

print(f"✅ Saved {len(input_dict)} notes to {rd_sample_notes_output_json}")


