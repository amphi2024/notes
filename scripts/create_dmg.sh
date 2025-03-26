echo "Creating dmg..."

cd ..
create-dmg \
  --volname "Notes" \
  --window-size 500 300 \
  --icon Notes.app 130 110 \
  --app-drop-link 360 110 \
  Notes.dmg \
  build/macos/Build/Products/Release/Notes.app
echo "Let's go!!!!!!"