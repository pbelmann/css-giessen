# Hello World (for bioinformatican)
This tutorial assumes that a BiBigrid cluster (master + 4 slaves, 16 cores each) is running and this repository is cloned on the shared filesystem on the master instance (/vol/spool).

Let's imagine we will blast some queries against the zebrafish model organism. 

## Preparation 

Since the "standard" bibigrid images doesn't contain any bioinformatic software tools, you have to install them beforehand.  However, the easiest way to use bioinformatic tools together with BiBigrid is to use a ready-to-use  docker container (e.g. [biocontainers](http://biocontainers.pro)). We will use **biocontainers/blast** for this task. Before we can start the blast job we have to create the blastdb and split the query sequences into parts. 

### BlastDB
We need to create the BlastDB database on the local storage (/vol/scratch) on each of the hosts. We will write a small shell script located at /vol/spool/blastdb.sh doing that for us.

First we have to download the zebrafish database from cloud object storage URL and uncompress it.
 
	
	curl https://s3.computational.bio.uni-giessen.de/swift/v1/CSS/blast/zebrafish.1.protein.faa.gz > /vol/scratch/zebrafish.1.protein.faa.gz
	gunzip /vol/scratch/zebrafish.1.protein.faa.gz
	
Then we need to prepare the zebrafish database with `makeblastdb` for the search.

	docker run -v /vol/scratch:/data biocontainers/blast makeblastdb -in zebrafish.1.protein.faa -dbtype prot

The (-v) argument of the docker call allows us to map the local folder /vol/scratch to the /data folder inside the container.

	   
We can now use the GridEngine to distribute the jobs on the
cluster. The `-pe` option ensures, that you only download the 
database **once on each host**.

   
	qsub -cwd -t 1-4 -pe multislot 16 /vol/spool/blastdb.sh
	
The above qsub command asumes that we started a cluster with 4 compute nodes (16 cores each). A ready-to-use script is located in this repository as **get\_and\_create\_zebrafish\_db.sh**.
   
### Query Sequences

We download a set query sequences from cloud object storage and ...

	curl https://s3.computational.bio.uni-giessen.de/swift/v1/CSS/blast/queries.fas.gz > /vol/spool/blast/query.fas.gz
	
... split the multiple fasta file into smaller pieces (e.g. 10 sequences each). We can use the split_fasta script located in the scripts folder.

	gunzip /vol/spool/blast/query.fas.gz
	split_fasta query.fas 10
	
## Run BlastP analysis
The idea is to start one blastp job for each input file. We have to write a shell script ("blastp.sh") that wraps the docker call of the blastp container and can be submitted to the gridengine as arrayjob. Blastp needs the database (located in /vol/scratch), the query files (located in /vol/spool/blast) and a result folder. Blastp expects the database to be in the search path so the database path must be mounted as /data. 

	docker run \
	-v /vol/scratch:/data \
	-v /vol/spool/blast:/input \
	-v /vol/spool/blast/result:/output \
	biocontainers/blast blastp \
	-query /input/query.fas.${SGE_TASK_ID} \
	-db zebrafish.1.protein.faa \
	-out /output/result.txt.${SGE_TASK_ID}
	
The environment variable ${SGE\_TASK\_ID} is set by the gridengine when run an arrayjob.



