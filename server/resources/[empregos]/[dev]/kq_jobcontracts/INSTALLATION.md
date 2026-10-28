## INSTALLATION GUIDE

### Dependencies:
Install our KQ_LINK resource if you don't have it installed already
- If you do have it installed, make sure its up-to-date (^1.17.0)

Follow the detailed guide here: https://docs.kuzquality.com/kq-link/kq-link-or-installation-guide

Github: https://github.com/Kuzkay/kq_link

⚠ Make sure that `kq_link` is started **before** this resource and named exactly `kq_link` !
___

### Step 1:
Put the folder into your resources folder

### Step 2:
The script should automatically create a new database table named `kq_jobcontracts_stats`. But if you want to be 100% safe. Import it manually from
`_installation/kq_jobcontracts_stats.sql`

### Step 3:
Ensure the script in your `server.cfg` file.
```
ensure kq_link
ensure kq_jobcontracts
```

### Done
Enjoy the script

___

- https://docs.kuzquality.com/
- https://kuzquality.com/
- https://discord.gg/fZsyam7Rvz
