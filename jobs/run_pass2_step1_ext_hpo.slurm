#!/bin/bash
#SBATCH --partition=IllinoisComputes-GPU
#SBATCH --account=jimeng-ic
#SBATCH --job-name=pass2_step1_ext_rd
#SBATCH --output=logs/pass2_step1_ext_hpo_%j.out
#SBATCH --error=logs/pass2_step1_ext_hpo_%j.err
#SBATCH --gres=gpu:H200:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=12:00:00


echo "Starting Pass2 Step 1 Extracting HPO at: $(date)" 

module load cuda/12.6
source /projects/illinois/eng/cs/jimeng/zelalae2/scratch/PyHealth/venv_pyhealth/bin/activate
cd /projects/illinois/eng/cs/jimeng/zelalae2/scratch/RDMA


python hpo_steps/step1_extract_entity_context.py \
  --input_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/mimic4_note/sampling/input_patient_notes.json \
  --output_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/output_checkpoints/pass2_hpo_results/pass2_step1_extract_entity_context_hpo.json \
  --llm_type local \
  --entity_extractor retrieval \
  --model_type mistral_24b \
  --retriever_model  abhinand/MedEmbed-small-v0.1 \
  --retriever sentence_transformer \
  --embeddings_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/data/vector_stores/G2GHPO_metadata_medembed.npy \
  --temperature 0.001 \
  --cache_dir /projects/illinois/eng/cs/jimeng/zelalae2/scratch/rdma_cache \
  --checkpoint_interval 10 \
  --debug \
  --condor

  echo "Finished Pass2 Step1 Extracting HPO at: $(date)"
