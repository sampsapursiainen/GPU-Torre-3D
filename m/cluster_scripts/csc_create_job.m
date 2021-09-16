%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

csc_job = parcluster
csc_job.AdditionalProperties.WallTime = csc_cluster_wall_time;
csc_job.AdditionalProperties.MemUsage = csc_cluster_mem_usage; 
csc_job.AdditionalProperties.QueueName = csc_cluster_queue_name;
csc_job.AdditionalProperties.AccountName = csc_cluster_account_name;
csc_job.AdditionalProperties.EmailAddress = csc_cluster_email_address;
csc_job.AdditionalProperties.QueueName = csc_cluster_queue_name; 
csc_job.AdditionalProperties.GpuCard = csc_cluster_gpu_card; 
csc_job.AdditionalProperties.GpusPerNode = csc_cluster_gpus_per_node;
csc_job.saveProfile
