#!/bin/bash
#SBATCH --partition=IllinoisComputes-GPU
#SBATCH --account=jimeng-ic
#SBATCH --job-name=pass2_step2_ver_hpo
#SBATCH --output=logs/pass2_step2_ver_hpo_%j.out
#SBATCH --error=logs/pass2_step2_ver_hpo_%j.err
#SBATCH --gres=gpu:A100:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=12:00:00

echo "Starting Pass2 Step 2 verification HPO at: $(date)" 

module load cuda/12.6
source /projects/illinois/eng/cs/jimeng/zelalae2/scratch/PyHealth/venv_pyhealth/bin/activate
cd /projects/illinois/eng/cs/jimeng/zelalae2/scratch/RDMA

python hpo_steps/step2_verify_entity_context.py \
  --input_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/output_checkpoints/pass2_hpo_results/pass2_step1_extract_entity_context_hpo.json \
  --output_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/output_checkpoints/pass2_hpo_results/pass2_step2_ver_hpo_context_output.json \
  --embeddings_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/data/vector_stores/G2GHPO_metadata_medembed.npy \
  --lab_embeddings_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/data/vector_stores/lab_tables_medembed_sm.npy \
  --min_context_length 5 \
  --verifier_version v4 \
  --retriever sentence_transformer \
  --retriever_model abhinand/MedEmbed-small-v0.1 \
  --llm_type local \
  --model_type sentence_transformer \
  --temperature 0.001 \
  --cache_dir /projects/illinois/eng/cs/jimeng/zelalae2/scratch/rdma_cache \
  --checkpoint_interval 10 \
  --debug \
  --condor

  echo "Finished Pass2 Step2 verification at HPO: $(date)"
