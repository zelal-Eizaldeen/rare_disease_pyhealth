#!/bin/bash
#SBATCH --partition=eng-research-gpu

#SBATCH --account=jimeng-ic
#SBATCH --job-name=step3_match_hpo
#SBATCH --output=logs/step3_match_hpo_%j.out
#SBATCH --error=logs/step3_match_hpo_%j.err
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=12:00:00

echo "Starting Step 3 Matching HPO at: $(date)" 

module load cuda/12.6
source /projects/illinois/eng/cs/jimeng/zelalae2/scratch/PyHealth/venv_pyhealth/bin/activate
cd /projects/illinois/eng/cs/jimeng/zelalae2/scratch/RDMA

python hpo_steps/step3_match_hpo.py \
  --input_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/output_checkpoints/step2_ver_hpo_context_output_v4.json \
  --output_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/output_checkpoints/step3_match_hpo_context_output.json \
  --embeddings_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/data/vector_stores/G2GHPO_metadata_medembed.npy \
  --retriever sentence_transformer \
  --llm_type local \
  --model_type sentence_transformer \
  --retriever_model abhinand/MedEmbed-small-v0.1 \
  --temperature 0.5 \
  --cache_dir /projects/illinois/eng/cs/jimeng/zelalae2/scratch/rdma_cache \
  --checkpoint_interval 10 \
  --debug \
  --condor

  echo "Finished Step3 verification HPO at: $(date)"
