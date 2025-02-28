#!/bin/bash

cd ./open-sources &&  cd flutter.widgets &&  git checkout main  && git add . && git commit -am "clean-up" && git push origin main
cd .. && cd qr.flutter &&  git checkout main  && git add . && git commit -am "clean-up" && git push origin main
cd .. && cd receipt &&  git checkout sql  && git add .   && git commit -am "clean-up" && git push origin sql
# cd .. && cd kds &&  git checkout master  && git add . && git commit -am "clean-up" && git push origin master

# cd .. && cd flutter_list_drag_and_drop && git stash &&  git checkout main  && git add .  && git commit -am "clean-up" && git push origin main


cd .. && cd flutter_slidable && git stash &&  git checkout dev  && git add .  && git commit -am "clean-up" && git push origin dev
# cd .. && cd flutter_datetime_picker &&  git checkout master  && git add .  && git commit -am "clean-up" && git push origin master
# cd .. && cd flutter_luban && git stash   &&  git checkout master  && git add .  && git commit -am "clean-up" && git push origin master
# cd .. && cd flipper-turbo  &&  git checkout uat  && git add .  && git commit -am "clean-up" && git push origin uat
# cd .. && cd dart_pdf  &&  git checkout master  && git add .  && git commit -am "clean-up" && git push origin master

cd .. && cd form_bloc    &&  git checkout master  && git add .  && git commit -am "clean-up" && git push origin master


# cd ./android && ./gradlew :clean && cd ..
# rm -rf ./build
# rm -rf ~/.gradle/caches
# dart pub cache clean && flutter pub get
# ./gradlew --stop