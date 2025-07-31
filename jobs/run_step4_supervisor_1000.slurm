#!/bin/bash
#SBATCH --partition=IllinoisComputes-GPU
#SBATCH --account=jimeng-ic
#SBATCH --job-name=step4_supervisor_rd_1000
#SBATCH --output=logs/step4_supervisor_rd_1000_%j.out
#SBATCH --error=logs/step4_supervisor_rd_1000_%j.err
#SBATCH --gres=gpu:H200:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=12:00:00

echo "Starting Step 4 Supervisor at: $(date)" 

module load cuda/12.6
source /projects/illinois/eng/cs/jimeng/zelalae2/scratch/PyHealth/venv_pyhealth/bin/activate
cd /projects/illinois/eng/cs/jimeng/zelalae2/scratch/RDMA

# Run the supervisor

python rd_steps/step4_supervisor.py \
  --ground-truth /projects/illinois/eng/cs/jimeng/zelalae2/scratch/output_checkpoints/testing_step3_match_rd_1000_context_output.json \
  --predictions /projects/illinois/eng/cs/jimeng/zelalae2/scratch/output_checkpoints/pass2_rd_results/testing_step3_match_rd_1000_context_output.json \
  --evaluation /projects/illinois/eng/cs/jimeng/zelalae2/scratch/output_checkpoints/testing_step3_evaluation_rd_1000_results.json \
  --embeddings_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/data/vector_stores/rd_orpha_medembed.npy \
  --abbreviations_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/data/vector_stores/abbreviations_medembed_sm.npy \
  --llm_type local \
  --model_type mistral_24b \
  --temperature 0.5 \
  --output /projects/illinois/eng/cs/jimeng/zelalae2/scratch/output_checkpoints/testing_step4_supervisor_rd_1000_results.json \
  --cache_dir /projects/illinois/eng/cs/jimeng/zelalae2/scratch/rdma_cache \
  --checkpoint_interval 10 \
  --debug \
  --condor

  echo "Finished Step4 supervisor at: $(date)"
