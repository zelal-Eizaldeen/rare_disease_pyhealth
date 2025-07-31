#!/bin/bash
#SBATCH --partition=IllinoisComputes-GPU
#SBATCH --account=jimeng-ic
#SBATCH --job-name=ext_demp=ographic
#SBATCH --output=logs/ext_demp=ographic_%j.out
#SBATCH --error=logs/ext_demp=ographic_%j.err
#SBATCH --time=01:00:00
#SBATCH --gres=gpu:A100:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G


# Load environment (adjust based on your environment manager)
echo "Starting Demographic Extraction at: $(date)" 

module load cuda/12.6
source /projects/illinois/eng/cs/jimeng/zelalae2/scratch/PyHealth/venv_pyhealth/bin/activate
cd /projects/illinois/eng/cs/jimeng/zelalae2/scratch/RDMA

# Run the evaluation
python hpo_steps/extract_demographic.py \
  --input_file /projects/illinois/eng/cs/jimeng/zelalae2/scratch/output_checkpoints/step1_extract_entity_context_hpo.json \
  --output /projects/illinois/eng/cs/jimeng/zelalae2/scratch/output_checkpoints/extract_demographic_results.json \
  --model_type mistral_24b \
  --temperature 0.5 \
  --cache_dir /projects/illinois/eng/cs/jimeng/zelalae2/scratch/rdma_cache \
  --checkpoint_interval 10 \
  --debug \
  --condor

  echo "Finished Extracting Demographic at: $(date)"

