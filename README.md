# terraform-takehome-challenge
A take home challenge for DevOps roles

# Developer Setup

The only requirement for local development is Docker and NodeJS. Once they are available, 
simply run:

```bash
docker compose up
```

which starts [MiniStack](https://ministack.org/). Then, install the Node modules for the Lambda:

```bash
cd code
npm install
```

and finally run:

```bash
cd ..
terraform apply
```

to create the resources in your local MiniStack environment. The new API endpoint can be tested with:

```bash
API_URL=`terraform output -raw api_url`
curl "${API_URL}"
```
