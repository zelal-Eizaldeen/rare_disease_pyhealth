#!/bin/bash
#SBATCH --partition=eng-research-gpu 
#SBATCH --account=jimeng-ic
#SBATCH --job-name=prepare_rd
#SBATCH --output=logs/prepare_rd_%j.out
#SBATCH --error=logs/prepare_rd_rd_%j.err
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=12:00:00



module load cuda/12.6
source /projects/illinois/eng/cs/jimeng/zelalae2/scratch/PyHealth/venv_pyhealth/bin/activate
# cd /projects/illinois/eng/cs/jimeng/zelalae2/scratch/PyHealth/examples
cd /projects/illinois/eng/cs/jimeng/zelalae2/scratch/RDMA/zilal_contribution/notebook/prepare_rdma_inputs.py

echo "Starting Preparing RD Inputs ..."
python prepare_rdma_inputs.py rare_disease
echo "Preparing RD Inputs completed."
echo "Finished Preparing RD Samples at: $(date)"