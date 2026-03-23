# Java_GCP_Demo

## How To Use 

### Step 1. Download From [Git](https://github.com/GordonWei/Java_GCP_Demo#)
`git clone https://github.com/GordonWei/Java_GCP_Demo`

### Step 2. Build Docker From Docker File 
`docker build -t momo-apm-demo:v1 .`

### Step 3. Create Docker Repo 
```
gcloud artifacts repositories create momo-demo-repo \
    --repository-format=docker \
    --location=asia-east1 \
    --description="Docker repo for momo APM demo"
```


### Step 4. Setting Docker Auth 
`gcloud auth configure-docker asia-east1-docker.pkg.dev`

### Step 5. Tag Your Docker Image & Push To GCP Repo 
`docker tag momo-apm-demo:v1 asia-east1-docker.pkg.dev/YOUR_PROJECT_ID/momo-demo-repo/momo-apm-demo:v1`
`docker push asia-east1-docker.pkg.dev/YOUR_PROJECT_ID/momo-demo-repo/momo-apm-demo:v1`

### Step 6. Deploy Your Docker To Cloud Run
```
gcloud run deploy momo-apm-demo \
    --image=asia-east1-docker.pkg.dev/YOUR_PROJECT_ID/momo-demo-repo/momo-apm-demo:v1 \
    --region=asia-east1 \
    --allow-unauthenticated \
    --set-env-vars="GOOGLE_CLOUD_PROJECT=YOUR_PROJECT_ID"
```

### Step 7. Get Cloud Run URL & Add Path `/checkout/slow` & `/checkout/leak`
