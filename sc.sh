       
      echo -ne '\n' | curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
      echo -ne '\n' | chmod  ug+x ~/.nvm/nvm.sh
      echo -ne '\n' | source  ~/.nvm/nvm.sh
      echo -ne '\n' | nvm  install --lts
      echo -ne '\n' | pip3 install aws-parallelcluster
      echo -ne '\n' | pcluster configure --config conf.yml
      echo -ne '\n' |  pcluster create-cluster --cluster-name cluster-1 --cluster-configuration conf.yml