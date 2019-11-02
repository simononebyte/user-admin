# user-admin
 A collection of scripts to automate various user administration task

# Top Level Steps

These are the high level steps required for creating a new user. I will break
these down into smaller, more targetted scripts. 

 1. Load config
 2. Depending on host check if run as admin
 3. Confirm user details
    - First & Last NAme
    - Email (if different from auto-generated one)
    - Office
    - Job Title
    - Ext
    - Qualifications
    - Remote desktop server
    - Groups (See note 1)
 4. Pre-flight check to ensure there are no clashes. Fail if found.
    - Does user exist?
    - Do home folders exist?
    - Does email address exist?
 5. Create the domain account
 6. Update the office information (User existing set-office script)
 7. Update display name to append qualifications
 8. Create user folders and set correct permissions
 9. Add to mandatory groups
10. Add to remote desktop group
11. Generate and set the password
12. Run AD Sync to get account registered on Office 365
13. Display account details confirmation. e.g. username and password
14. Display next steps message e.g.
    - Log into Office 365 and assign a license
    - Add to the correct signature group in Office 365
    - Log into Exclaimer and sync details