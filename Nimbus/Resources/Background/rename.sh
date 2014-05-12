for i in $1/*.png
do
mv "$i" "${i/~ipad_01/_01~ipad}"
mv "$i" "${i/~ipad_02/_02~ipad}"
mv "$i" "${i/~ipad_03/_03~ipad}"
mv "$i" "${i/~ipad_04/_04~ipad}"
mv "$i" "${i/~ipad_05/_05~ipad}"
mv "$i" "${i/~ipad@2x_01/_01~ipad@2x}"
mv "$i" "${i/~ipad@2x_02/_02~ipad@2x}"
mv "$i" "${i/~ipad@2x_03/_03~ipad@2x}"
mv "$i" "${i/~ipad@2x_04/_04~ipad@2x}"
mv "$i" "${i/~ipad@2x_05/_05~ipad@2x}"
done
