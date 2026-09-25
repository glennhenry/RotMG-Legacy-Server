#!/bin/bash
set -e

echo " Building server JAR..."
./gradlew shadowJar

echo "Build finished"
echo

# shellcheck disable=SC2162
read -p "Build documentation? (y/n): " BUILDDOCS

if [[ "$BUILDDOCS" == "y" || "$BUILDDOCS" == "Y" ]]; then
  echo
  echo " Building documentation..."
  
  cd docs

  if [[ -f "package.json" ]]; then
    echo "Installing dependencies..."
    npm install
  fi

  echo "Running build..."
  npm run build

  cd ..

  echo
  echo " Moving built docs to deploy/docs_build/..."

  mkdir -p deploy
  rm -rf deploy/docs_build
  mkdir -p deploy/docs_build

  if command -v rsync &> /dev/null; then
    rsync -a docs/dist/ deploy/docs_build/
  else
    cp -r docs/dist/* deploy/docs_build/
  fi

  echo "Documentation successfully moved to deploy/docs_build/"
else
  echo "Skipping documentation build."
fi

echo
echo " Build finished successfully!"
# shellcheck disable=SC2162
read -p "Press Enter to exit..."
