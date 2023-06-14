# Retrieves a randomized username and password from vault through kubectl
# the reason why terraform provider is not used for this purpose is to prevent
# the created random username & password combo to ever leave the vault instance.
# through this script, these values are created on the vault instance and then
# written back to the instance without any round trip.

kubectl -n vault exec -it vault-0 -- sh -c "
  if [ \"${username_randomizer_length}\" != \"0\" ]; then
    random_username=\$( \
      vault write \
        sys/tools/random/${username_randomizer_length} \
        format=hex | \
      tail -n1 | \
      awk '{print \$2}' \
   )
   random_username="_\$random_username"
  fi
  random_password=\$( \
    vault write \
      sys/tools/random/${password_randomizer_length} \
      format=hex |\
    tail -n1 | \
    awk '{print \$2}' \
  )
  random_password="_\$random_password"
  vault write ${role_path} \
    username=${username_prefix}\$random_username \
    password=${password_prefix}\$random_password
  write_exit_code=\$?
  if [ \$write_exit_code != 0 ]; then
    echo 'Write failed'
    exit \$write_exit_code
  fi
  random_username=""
  random_password=""
  echo \$random_username
"
