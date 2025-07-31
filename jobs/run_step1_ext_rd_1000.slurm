#!/bin/bash
#SBATCH --partition=eng-research-gpu 
#SBATCH --account=jimeng-ic
#SBATCH --job-name=step1_ext_rd_1000
#SBATCH --output=logs/step1_ext_rd_1000_%j.out
#SBATCH --error=logs/step1_ext_rd_1000_%j.err
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=12:00:00


echo "Starting Step 1 Extracting at: $(date)" 

module load cuda/12.6
source /projects/illinois/eng/cs/jimeng/zelalae2/scratch/PyHealth/venv_pyhealth/bin/activate
cd /projects/illinois/eng/cs/jimeng/zelalae2/scratch/RDMA


python rd_steps/step1_extract_rd_context.py \
  --input_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/mimic4_note/sampling/input_patient_notes_1000.json \
  --output_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/output_checkpoints/testing_step1_extract_rd_1000_context_output.json \
  --embeddings_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/data/vector_stores/rd_orpha_medembed.npy \
  --entity_extractor llm \
  --llm_type local \
  --model_type mistral_24b \
  --retriever sentence_transformer \
  --retriever_model abhinand/MedEmbed-small-v0.1 \
  --window_size 10 \
  --temperature 0.5 \
  --cache_dir /projects/illinois/eng/cs/jimeng/zelalae2/scratch/rdma_cache \
  --checkpoint_interval 10 \
  --debug \
  --condor

  echo "Finished Step1 Extracting at: $(date)"
