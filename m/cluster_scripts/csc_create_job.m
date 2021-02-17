%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

csc_job = parcluster
csc_job.AdditionalProperties.WallTime = '24:00:0'
csc_job.AdditionalProperties.MemUsage = '16g'
csc_job.AdditionalProperties.QueueName = 'small'
csc_job.AdditionalProperties.AccountName = 'project_2002680'
csc_job.AdditionalProperties.EmailAddress = 'liisa-ida.sorsa@tuni.fi'
csc_job.AdditionalProperties.QueueName = 'gpu'
csc_job.AdditionalProperties.GpuCard = 'v100'
csc_job.AdditionalProperties.GpusPerNode = 1
csc_job.saveProfile
