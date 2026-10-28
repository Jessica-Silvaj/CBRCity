## INSTALLATION GUIDE

### Dependencies:
Install our KQ_LINK resource if you don't have it installed already
- If you do have it installed, make sure its up-to-date (^1.21.0)

Follow the detailed guide here: https://docs.kuzquality.com/kq-link/kq-link-or-installation-guide

Github: https://github.com/Kuzkay/kq_link

⚠ Make sure that `kq_link` is started **before** this resource and named exactly `kq_link` !

___
### kq_jobcontracts
This script requires our job contract management resource. You will find it on your CFX Portal.
Make sure to install it by following its installation guide

### kq_powerwashing_mlo
The script comes with its own custom MLO. You can download it from your CFX Portal. 
If you do not want to use the custom MLO. Simply change all the locations in the config file.
___


### Step 1:
Put the folder into your resources folder

### Step 2:
Add the power washer weapon to your inventory/framework.

You can find the item/weapon templates and icons within the `_installation` folder

The weapon name is `WEAPON_KQPOWERWASHER`

- Most modern inventories have a separate list file for weapons. You likely do not add them to the items list. You should have a separate list of weapons. Make sure to look into the docs of the inventory system that you're using

### Step 3: (optional)
Add the `powerwashing` job to your server.

#### ESX:
To add the `powerwashing` job, simply import the sql file: `_installation/esx_job.sql`.
Then restart your server

#### QBCore / QBox
Open your jobs list file (usually found in `/shared/jobs.lua`)

Copy the job data from `_installation/qb_job.txt` and add it to your jobs list. Then restart your server

### Step 4:
Ensure the script in your `server.cfg` file.
```
ensure kq_link
ensure kq_jobcontracts
ensure kq_powerwashing_mlo
ensure kq_powerwashing
```

### Done

- UI Styling can be configured in the config of kq_jobcontracts
- Interaction/target system can be configured in the config of kq_link

Enjoy the script

___

- https://docs.kuzquality.com/
- https://kuzquality.com/
- https://discord.gg/fZsyam7Rvz
