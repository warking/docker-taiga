## Deploy
Modify and check all the environment variables in docker-compose.yml and then 
```bash
docker-compose up --build
```

If you use a nginx front to do HTTPS stuffs, you can refer to [nginx.conf](./nginx.conf)

For the initial deployment(which means that your db is fresh new), you can run init_admin.sh to add the default admin/123123 account 

## Caveats
1.If you use google's smtp, you need to goto https://myaccount.google.com/lesssecureapps to allow(TURN ON) less secure programs to use your gmail account
