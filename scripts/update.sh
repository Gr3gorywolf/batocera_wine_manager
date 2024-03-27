WINE_MANAGER_EXEC="/userdata/system/wine_manager/batocera_wine_manager"
echo "updating..."
bash ./install.sh
echo "running..."
if [ -f "$WINE_MANAGER_EXEC" ]; then
  "$WINE_MANAGER_EXEC"
fi