#!/bin/sh

skip=76
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

bztmpdir=
trap 'res=$?
  test -n "$bztmpdir" && rm -fr "$bztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  bztmpdir=`mktemp -d "${TMPDIR}bztmpXXXXXXXXX"`
else
  bztmpdir=${TMPDIR}bztmp$$; mkdir $bztmpdir
fi || { (exit 127); exit 127; }

bztmp=$bztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$bztmp" && rm -r "$bztmp";;
*/*) bztmp=$bztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | bzip2 -cd > "$bztmp"; then
  umask $umask
  chmod 700 "$bztmp"
  (sleep 5; rm -fr "$bztmpdir") 2>/dev/null &
  "$bztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <fajarrkim@gmail.com>."
  (exit 127); res=127
fi; exit $res
BZh91AY&SY�&�+ y����������������������������������4��  ���w���oxw_��������ݳ�[�g}�������w}�_}�=��ϻ�k�ݹ'��������󾯷��o�{��;{�^��i��S����}٭��a{\[��Ow{oV���w��m�n�^��[{�n,��j=��m���D����[޾��~&�
	�h&� 3@L&&�12i����?F���4S����	�FL	�6���� d� ѩ�hѠ&�e4�Ld �0	��L F�����Ʀ=&F�0��d�ɓ�@2 56@i�i�4ɂhѓd��
c@���l�O&�Mi�&M0Lђ<&�CI��M	��mOF�ѣ&���ɣɁ5=5<�Ry�6&	6Sɚ���0�ULL�'�D�<�@ф4Ҟ�LA��d�m�I�2�511=%6��LHx���"~�����4�6����I���ȧ�6	�S�`
�6L�aSѓM0S&?Sf�S�f� `FOEO�{!�J~#mG�P����z�&����zS�T�?M3Q��4�4�=<	��L��H��&���&�&444h& L#��==6� hLM14&�h��#���a2`�O hi�~
a��ɐ�l�A�	04SLC��0�^'[���pO�|�018%�D��a��4�g����bb��{�Ā�]�L��\� ���W��N��9
.\ߍ�QB����d "�1�O����}�t0�d}��lq��vJJ:N:�N#�(�dGd��<�i)d�_��+$���o�Lµ�A��Ř��U�@�G(��	�4��GI<C����"�#�>X�~@�@x�DX`4w�[c��9ml��du� ��`7�!�0�#��-���,fݕ�'s�	�L3�D`�l{��\�v�
^�0�����:[B��*�a����ʪ%؊��вo�k�TJ�,DPW�
�9�sq7������5��z�1ڏ�A&#M�eU\� �E
6�d��D�|�^���G^_,�9� ��=������X
!��""�?��&�DA��r؁�;U�H�\�ߧ��Rm�=�y��]:7z����i�V
Vo�`��X�7'��
;�qn�_��
�I�*I�vȗb��Q<����V���\���F��CK��Ո�Fk��"�b����e`��w��l���a��W���B�eX����"� �$�I"��:Q%HDD�B LqD�=+�a*1�,*�AB�� GHġ$$z(���(���	�|�S�,��R���5� xLCZʶ��JB,.���D2����� P�	�&^�-X�&h�#X@�0a�L��a����5�D"���V	E
d��i�T�
�$���P�HE(yD"~QB � e�=X���D�D
K�
PXJ"�	B�"��dye@��`�D?2��U%\�iH���ƶR�D�@������!��J]�7#���]q�M��������^z�9�a� P���&�Ӫ,PM[�۞���gB
"S����4aN�B�n�S����d�_�:�jֹ����^p~Q\�i�]{� �k�?�	s)�d����l((��V��HH#��QNG�y_Ѝ1D��K���|��ł���X��#�}�G�E���e9��%��=w�r�u*�q�m���.">�*��Y��.$_�<��q��w�{�25iF���F��1x�l�ˍ������9zƓ�5��wG�8�^�n�n�Wg�DT�?���0#x㣒�Zh���2�1�?���;n�0��b�GH��f�׼?������ׇ�>E��ˀ���"�+�7eT�/Dj
,����5����D�(
�D�y�5i�!�N7��]a���u9�؀�D�@�aQjĨ���͂��MA2���=��ݑ��(_���vlr�,K\��)}k>R������(9_����c\X�K1 �Jrpݱ�Ou��q���>Y�h(�0B �D��uF���#P
&�݈j���V���X��z�>��Z�W�q���Ot�$��hź|��`��n\�v+j�/�v̳O�P$���[��L�� �r�]]��؉`nHRO�w$��*ۥ���=���=�����4�|����g=o����GZ[���Jw�Wg=� �uƭK�x���+�4�<@a7շdX#x(#�r�ؿN᫕�3��s��ۯeF�B��i��r#�51�Pm��<ބ��{u[/О�_�bVb+>z�m����V�(J��ؤ�  �r5[ ���a����݌�l+?�����]��M��S��1��֢ ���z�F�����.�M�m,�S��⋻���4ĨU��P-y� �9�9�r#��f�ͺ�Tpo�??��k�W�:�j�ER���G�2���mS�vt:ks8�?�]���V�}�͒�Qk���eɤȱ cI,BI$�M��^'|��	����
���&����hAG�RinY�}�L��@�t[���z���,����7�Z��  �Өz��#�o��zA�CZ��,���J�e���E��1֭<n4��óQ�����Wq��I������B�5��i�_�DĶ�
(�2l��ʺ
X�9�?��T���\�K{g0�
���0Q2A��&TҌm*�u��T'"�8�MҾ�6B��$O�6a��O<�T�:�in�3��fOm�����Ykt)=��,_�QF�AB]<M���얳+�I�2Ō�J g��~���|#��8E��\�2�^�b)�AD�㮐+��`
�	�W�qې�\��"H�oa�Fq�;&��Bۘ���/��t��Z&d���Cv�{Zh@��]� �,�_�s(��b��������rxNYSb5�zǃ<�
��o��	�, (�B��B��#BL� �ʍ\��i���P8��i��-F&��	��eG%&���M���|��\ �2;᠆}�@蠀 �ML�`vR�U�������6J�~	�lҫ�aRh`	��վ���v��Y����3Y�P�ޤVѼ�c�0���5g����u�@E�����,�	�4Pp��٪�. �$�?��R|oUg{=F?�^Y��.�ѯW�cg:��x��4�0}�Z�Ӓ45̃w�����O��`T8q�(�\#���K��	�={F̓m
nzZN��#S�S� e�x�^^Ekx�_+n�߶_�Xot����#��(��lv�mtj�c���e����m+q�j�)d��N��bpI��A��b ,
_Mȵt���X s�
����}��ޤ.�
{͔����#5�⿺H(�N���ڠ`�5����X�q��x����u�q��"W�l~�����בY��\���Dl�'�^�7���K�S�l�U�\�]�R��+�OP%2���:||+�]+���{��j.�k�ǐXe�ڞ<�=�ѨgY�:�i,X��a�U���n{"8H�OǊ
Ǭ�.�{�-��m� '��6F`�:0p*j���g�,]�i�U)l+"�᳍�cS;Kj��b�̞c + 떊���dq��Z�E����v�<�o�ͱ�+â��]8��@��/��j�Ø��FC"�D���  �������y�g���%������d3%p�����|��B�2i �m������;1�n�l���n�p�qV�|�B~;}��pc٪��<qF�a�o�c7�
��UF����|�n��P��%���򳽳����z6B?���Gc�l�3ng�����<R?�b��_��kZmVf�I�	u^CM���kΞ�_E-������;d��F@8Ki�E+�1k�b}Qʣg@��-���\ m_����?;���k^�8�oI��W��O`��`k��xT��{3MVQ��a��Oh�󯸶Vs�꒬H70�R�� y�w9�xŅ�Xe5p	1g�U��gb��V#�-��.��\��AxUI8iq�{���3 [(15���͂q�ӛ�y�jV	����rL��<���L����Ţ�;%m1�2*%��Y]F�_���%u��+(�q�3��wo�3ڐu��+�F�t���q9�GQ+��<x�H� q࿠ ��Ν��V��|���H���᫱(U�ݓG����:r~��g"W�٩1�4��U�j��I��g�'g�Z<ŧKj��|-����K�Ԩ�`�����(�]���J��iHS> �J�Պ�!���2&K���I��]n���/.�b��\���$��Cz��?�U�lw��1�-S�؛�{����pL5���|�H��2�pXj��
���E�B�ֳ_]���ӆ.l]F�E�+Ufmq|i�������myzo+��>�?���bY�6��
����b������X:�K��rt-/�����t�f�{5�e���If�l��;�;岕�2ݸ� �ήW��	�+�>ɪJEG�)7��<8>>�"��"��Ҏ�ИfH�Y��d���^��el�[���qEsE=��ɟX�5X���o-���k?�:|��",oŀ��ݺ�MC�q!oJ����D�(��~.l���\'�op�"�F���Xp�owݖm����=&����Z�$g�Q����m�Bm{���[��$�@:��D�f���u_�\��}��G؝��}���]�Ux�d\SDl8��F���[W��sV���t�d���� B4��|\2{C%��Մi��W��0���?��o+sԕ]�<w�O���!�]�E�Iyq���Vw6����F�n��̜��\��5��
O��[���ㅓ[5�ih֦'5�?��L�����]gg1|ߦ�j�+:�Ĵ�·e�cN���D��Q�Vi�92O�|����\��P�Y�!�3����Qa����Xh�
rQ.l�;�԰��iN6��"�������Ź��<��)Z*e�;[�u��o��/0��:@DU�^I�A�h�\�l�߅n�l�]�+o����< �{�±�lU��zCBt���V� �Ro������ ;z���\o .m*�L�s��^�dt[7Υ��w�k{S�
L�t��ե�A��nz��%G�}�aG�Q^�来�X�ZE�vD���B8�ц��޺��WF~�����ϣ-�E��Kuʘؐ���`@�.������sM���Z��j�>}s���"��|+�L�b�Sn��X�{�?�q���akb���j�]B�^�Yѷ���M��7,���҄��՝�xNP�J?n����e9%=�Vs�V+d"eu��bг�B0�
�L�>�}�r��4����b�e', ��P�貐3l薂x�p�����۪�;=��x��`��:���/�I[�j�Z_�n�FH��5qD�Ɂhӳb�R|v�!�䧫��ge��Ƶd���Ԑ��J 	P 0z�������<糭"�Q9��*������.Ǉ��_j�~<n����f'pz����z�'mm䕐��wF}�Ǯ�Ƕ���W/
�-�E�Ĥr�˽úM}�-Ip�uf��`�bt��W�yZ3 b��.��؎w�)�u�/ħ��#�}!�{X����چ�R���rL
����u�����!/�+7��SAC���[8��
�%.,OKįfs��q�60c/���a�*T�4ް�ă��=r~�f���&��Q۲���9�y��\G�N�y�.�� �̼�P��L&�����l�Էl6R�S���s�pVo.�C���Ep j;�����%c�rSF�Էú%$�k�B��G��r����a���8�����JCJc�{�E����h���«_i�o�礕��P�M}��xd]3�<���@��E�
�+�����_�H�Od�a��������>k�"�^��N���!�3����2)^����
dTK�r&��V�6s[:�OWzgϕXb�hτ�u&ȥ�0Ў;���5����[�il$7_Q�ڇHk|'��=���X��P����]�N�z�?���g;~K�Eh-�O��$9 +���?��q>��W���D��xG��AT�&H�����T�+GO�)6���������~��g`_��|��:z��'� 扷�I)<�[tT�]�����J���`$�^��ڹR�2	�_��^>����|��\	#�5�%;�a:S��.�[\Fi�5���mȽ���,c7:C������G)����J�~�WY
����4�{� "ݧ�|��Vl(g�1��Rt8��4+�*u�dCtR-r`��b�n\�l��U}�T/�8Ҹ֌66f���(z��
��_.}5��!�E��gt{C)}[��!��"
�G�CF�?B" �����	�����'�rg��+4���|�y��2����L�2���F�!���W �#.�c���Gd��`kWJI~�RӸ(a�1<�͘?T1߂��b����;�j
ӄ��UJ߁��Q]
$����#��3u�;u�Q��W�p�_�7�/L�/�o�����l�3�^po�Rj����_�u�]~��.%Eg\tp7��{Z9[D^+�E�����ԟ&.���_�aܳ$'�v��Ն)��;�&���<oo���g����޿�ӷį�g?���ǡ�<�L��a�z��;1�����A�4��UtM8���i�A}�-E�����A3b
Y%�MI͟E���Rc�{#u���Z�r_���8� ��;���t��C�_���Rxpa��͐���#�Mz��Y|�|��������j����ޖ'��.����6]�J�mk��ϋ �f�y�j�3}�.�6����ۂ����^|��>/�W��+hm����=�7
J�ߍ��g`�Їȸ�OI��i���e&
�F���f\��Ӹr������6#rrL���B@n~��UqeEk������!�H��Z�1����!��Q� �߁����NlQ��9yv`|�K����3��m���6�3���'�d�n��b�z���5>~�/ j�[H�ķ�2�����;����e]:/� �4��1�3���:��������"�����|�,�8^���y��/��
�!�&�����}=ɑ^�!�C��J׭���S���N�>��3�k�h����|�G8<�
�L�����6�L���s���r������'+���^W>�{ 5ah �@MV>Ч�W��++�P���?�}R�(kIa�*�;��9��Cl3Y�m���;�R r%�`����O�4�c�l���@ ����4Q8O¾��_XDe(�O���$�[c�;zR�?5�þ�%� ���^ժ��))���4r���,�h-�<.����2�����K�X]���A>�\n��
�ڈ��ff=���GW#{�����[yld))�.S��)��I��L#nc�I��U1,XVY�F��\�w!.F@C�22�#��H� d��a�=�.�����B4����+�Kf��0E��ĨZ�g�,UD�,R�<����TjK)	X,#�Q"�,���m<���p��G�4��Oy�����{��;����������~ ��Xgm���N�#�W��|�t_���k�6��
��$�nNh=��~g�/��,+��)#%ۍO05���GiY޿��(H����X.�N�=㴍�"�����}�fUN����F�/z�X�m�+/�A&Q�_�oGڅ�]�	y��VY=#P�����Ǣ��K�%��)!�#1��J�3�3^چ�d�
Ap��Z?�0b*8�$��u	~N/�&#�(�fh��c����I�P�H��(��E| �-����G���U8ϫ��ٻ�ۓ��Z��h @d`������T�7�=�7Gnl�hc,v 8'fg&=G`��s����Sz�����&���w���q��~֐����&�r��d{'�!�_�F�}�?�lJ!?�w�u��-A�w�x�o���ɗO9��w�2�m��4<V�X�T�i.x�k𡯖-.O���������Ar���T`N����u|X��@v�\��V�������x�������&g��z��e���'魈��X��d�r�a/t��_��GC�n�r��7���껿	�O�܅��Ev�a��Y:W��<vL�wAf�RnGCu�y�����,f/9��J�f�;���p��&��[�+3�+���Ox�6���l�H���ш�9}��e����T���*eb�O���
������^���"�wma���V�Y�W�%�GsS
�~*k�'I��`�3�z��������H{�d̓���u�/,x78 s��^�R+
�޼B�G�lۑҳ���TcOg�;���!t{�+�v��dVG*� ��  �~wV���g���hJ���̨ws�WTO�6^F��_�k����u @L��V�S��Z= Il��m�*���N�p���򽾽K�"��}C�����h�ت��H?����#m�?e�	�ya�����Un�,0�z�K1�]�l*�ht�Y�h���Y���)���I��2
K}�Bɳ�>4��0D��2���ƺ�=^�7�w�Js�p�����3dt��	8�B�9�Ԩ�5��"�������t�R���dc��+�m�<.(��_��$�5
ZR��Qn%D(fo��i��W��� ҕ��5�>�qgCBL<W�VS��f��u��~p-����*;V��Ϣ{�h�\��g��Y� ��2?�\}h%���Ƀ���15�|���;����z=�u��)w���c�w���U~D4JA?p��@�s=tr��z̏����Ĥ-�euE��
V{R�^{��0���q��[��x�G�� l<b�ʃw&���e�br
�?2����? ���z͇ھ$2�^4ͪ����TM<E$.�W
�D�p2_��w�NS�fh����/�9(��Ѷy=v���u���ج��Nh�e��#E~�./�������o�|c 2�[���'L�>�%��y����35����1i�$����x;I�uփ�Qap����6��H�M�4'�:��
w��
�ƴ��C���3����ֳ��Rq~���Y�Zw��9.��w��q���9
Rk��Hk���7�� ��zk[Ѯ�T�QN�������Ի��(l*���?�;��=���6S�me�E���@I~r�u'9q�0 %�PW_A �� �' �DDSǎ���~���|�r�9���k�)
�
����lt�)J[;
ү���dv�i^���U6��'��Į���-�$_.�
0��giA�=^�
nv��$͌L��+��4�i�eM��5�6��g4P#��	B!�Us覩��%|@
�^0`2�9͸��uK	�$9�l��է��n�4x�պ���\�k�&��S����@�sӴ���
h�BK[��8(�V"��V�pxx`�I��@U��{��C��a���;_	�ͭ��e�l��u���[v�����f��j�yޥ�����`c��V��=��0����>n�?ۈ��m-[�*pFDsǓ�68� T�!X�G�����;��>~���g�h���.�w��}�Q�Щ�Z�$�:7f�8��S9�ݷ�I�Y��``N �� ��~�W��`�(}>��S������9#:j�s:X�^ޖ��?���+����V�@c��D͑t���g����٥?~���n�gM�ڭ��4�����<്ۑ���:�l�窹Hq�gf��+b���G�à�{���7���9G��|�+��^�d�CJ�z���$����!\��Mq�� /�\`/��s݀�e��W�Af�D˻������et�O?w�_�vn�d3�+��x	ߦ̀J���r<��C��*�̝W�ȼ>�"
���b|�P9�9:�ܿ�vQ��������~<��\cr�ݪ��`b܏��>���8���<�[<L	���X2>f �Ff�r�M5]t�&�m4��GrSr��p�	c�_g?&����c�jy�JO8�\e�)��wIkO�{�9�}�ID�4=�z���(82�ξ� ���T�( d]0���4:��`�%��GH��4,X�0�Fy��>
��'�t��e[�B���M�i�n�\����5}-;��T��Fjn���S��X��Яx���Q6�S?�%"��Ż���b>m`��p�~�f��,��?h�{9q,�JG ϞN����K5���%ȵ�o�;���Y��#79�4zum̛�`�x�"� D %�QX��x�)�.�1kSt����� /�Mn�8��jj�G�_�nȠ�۷���I�������~H�e詾��p4N��|}-�Kc
#�3��U����{wg�A��'}W��Q�F>�<�"��a�ǚ�2h4��gF���9wv�x_e�61]&��a�ό�����^������^Muk�ض��[�:���V�'�������(���m�->NuV�nK]D#vE��'L���h���L�X��GT�-/
���ٍ�M*z͗��~^V�eO�yɵ}�T����kG�e�Z�G��%#�ze�rK�:�r�����t�ode�
��R�kjj�fz�i�K���*���y�({��u��a�\z�6!��m�c����U��̈́������\y�_O �K�$���
���?-O,���N�|�	e�Gb��v����,^��PEZ���������.�K�>�9u�Sj>ľ�R�sn�-�V0��
�܍���GpY��#���gd�����d��A��g�Y�s���_6?�O��Ͳ�<k`�+)`�O�U����_��zr.�Ƒ�o������A���K!���6TYZM�
Cxdo+9b}�q=�ų�ՊJ�fJ2J����HP]�=$2ZU-� �w��6=����.e���s���c�'��z޴�?�b���%bX�UT�G��Dw��x�����3�!�A�6Z
˸�����HCG��q�������D ڄJ@/:݂A�WbJ+�Vo�^ģ|�tS�\2��\>��PF���!H6(���\|n6���ڂٌ$JҎ@������:9@���Ae3ߞ"��c�	�ί�SKA謥�MB��3�º0�#YJW�ᮨ�g�BuyD�@�S
V*UH�ef�4|?u��i
��N
�]�@ډ
Kϰ�J⟲P�+�a��>����T ��<<v�cgTs
n����(��IR,��%o���W�6�����bk���|�
=A��s�i�Y�=���ϋ�u�,��z�da9{�9��{�V7�sE^:�23*���0�-�e�>��
CNe���uЧ�7뺕ן*��A8:���$r
��Ϩ��k7V�7�@A,�J�y�e�?iR��:�`ܺ*k�]���zV~�	lΣ�w��Y$A�l�6#*Z�˦��S�=����SX������)y�Gg�8�/�������?����^���"���0V���Tg3��Yo��8��X�	��O*�N�r��Q�����:�!9��/h&y+<a�Y��lj���8���xZ1uʖ���K
��ۏP,}��rP3n�q7�뵩C3���K�~�:�Izӟ�'�y� ���l��]"ܡ�}C�I���,8�ܕLCn559�T�������99�"D���v��y9��VEL������~���f#�T�%�c�0
�
2�5XV��ؑ�Z_�2#z�E��@:���t�d^y��7{4{�'���J�w=�9O�|�4 [a�L�@�D��?���P��%$�ȣ��<�,	�+�L�6ߕ�a��#�5!�����`�&|x,t���U�1�������We��m
���S���d�_%塚�H�y���>E8��ڄ��Ur�Fz �z�
�	� %�M%Ԗ��u����.�F�����θEv.	F��){; /A�v  �����I����|��ՋXÑo{���Z�}�B�����8d@k������GC���o��8���꧿횚<M[[j���@����+�d��\�������쥚r��N����<M�W��❝�A����cg�|0~�
�E]I�\��Ԛ�O˦�Y7c�A�:m���q��&|�.㶾nf���5q���`�x�W��z��d���?�z9�#�m���@}��߼�[�y��5��<�|~�6�����w�Kh�v�k���E� ��z���5������bz\�()��";��78��ݓO`A����N���2���Q5���W��~}�zK���t��N��F�)��(�6C�>	I�>���x�I���XYF"��]����FsV��Bw�tN��]���{��bi!ć�姶o���T��j����,귣M�b�ق��k��<h���U��������2�/a�� ���e��w��y[Hǃ��AH��>Pk��1xte�>_�BI��"g����e|o�{w�В�nٽ�P��+X	N�9+c1�t)�x�rF������w1"H_��!q��At6�9��QvGhKwzc���^r�����A&�IU�Wѧ���%Y��?��� 	pDq���bb�(��L��Ê(������t�3hO�����M����� d
���
Lʩ�C}wJ{�>{1��z�K��Ɋ�l�uo������|ו��&�?��ط��I$e�#��wv�V0t��ܳ�u�6��2�*��t4��?����pS�h*��XH�ݹ���I�o�*1��F�9��'�������S�mPX���$N���i2~�@ε��Z1�y�{�c��;I��.��:u�s���U����c�L���ذlR�Z-δ�� �:A�M�?b-���rVZ�<�=?ٵ�eAZ��������,Hd��̢��(����.�pE�e$oq��)��~�9��_X�C��1�D"ܱW�����O��׻􀮱��5��sr�
R��q/�D<��C*8ng�-mr���2L�)����H����}=ɜ��~�>�yTEXr�V�F�
�p�'f�K�V�f��ݮ��7Ě��Y��t(y$�:�Ճ���v��(�Ր�~͒/�v�tܤd
��~��B�D,��9��Xf~)��'p�B�s�I��^����T���aʵ��F�a��W�;q�ɬx�۞^.?��!��بa���^����J�����zz�SOxeb���B���i����Ǩd]^X�'P��uw������$�U
���e�79:IJVe]{��cB��<6�(ejj��Z�	��_je<��&/d�ݎV�Q��l�L�J���(Aڍhk(M�.&ݿS�~*ñ�[� ���-_++�<w�-����	N[���}p��ݪڻpԋ�1`T۫ 3]B�G���k�T���/����Ɣ�n>���*	�|��]uI9ڍ/�"I2&G�F��BNW��y �Swd,^�u�F��_W7�^��hK�6kY}�B����￑�Q}NJ+����-���*�K9
���:��ŧ7�^� �k��ȧLA���[X*�n�q;{P>�b=\��/8�V��ڝ�<����2b���]��jQ���wE���x��#��@�2����rJ�,�7m2˭\]�u
пC��z+���zp�`bS�;�M�3�U��4����f�1%��@�;�;�K�r)���a���p>�e�2�ٯ6����`�+<�u�0�^����7b��k���6��G^�:��|���ny�%��P$_��{G���#�tF}��,�3R��_�Fܣ����PMڤ�K�z���*jP2�@q�C��gl��O���]؏����IJw���J����E�T '�8��
�6U�XN8�jFK�gg_s�#�
r-�uM	�(�7J7(q��1�+po�1�<
>P�.|zh}�2)�{�G�E*�Ja������Q�T��/�ر���G��=͍�B�����V�#��U�x���kfZ�c�Dnoݤ�<r�s2-h���W�
�+
4ߙ���-���e�.��&
�����lN&��5���s��0���,�^���mX�F��0�١�=yM}����4��>ط*��J	-7dR��(������춛�r5Z��@�nm
��J�ڜ2��<�QH��8s���bTG�t��I�*Zx-!0�#﫼=Қ%��[��{tn<tZ�)~V ���ʯLЦ�Z~��&'���[͋tږ�vZ��}�:�5�o��,|���+���V�Q��rp�v�峫��B�UKg��d�.������BO	��j.=5'<�:S�*t��g�iK��r�w{�9�(;���ݖ<}G���6yE#�9d!����W��.��c`�[��8ӯ��o�_��y߁Bc��<�o�g`��ר�Z&,���|F	�};��o���O�}�EP�O!����iGj�+$����X
����N��υRҏDX�i
ޜ�D��$�*S_�s����C���:��׏�ܳ3�:�D��C���ty�w���� ٔ�;raoYK�����µ$m{q�hc"��vj����O֕>�̝)�`?��4Uy�o>�o�e<A���b��'�`)
�LBQ�p$H�����+���Y!��*���`�|�:��!>/֥#`4�[�"&ƞ�G�N���Z�5>f�*�ޅ����D�@��t2��B��a_x�[�*�*��}�.c�6V�7,�)a��&�����J�<����V_�}:RL��a�]yO�
��a{�dGN�m�W,��ޔ�eF]ݝHy*�w��ʖqЎY���Up�w����ԫ���F�������'���7f�連C����7H�ҭǹ$o�C���W�0=mj8���.8�l�Qj[Xh�ktj5��ݨ�C�9��$�Ɗ�.��Ж�ix����̡VS,�{��3O��?v]��
X������n/rv�D���,��K���C�8|�����A��	B�.�Gp�oz���k6�IW%�_IѦ�~�;A�R�
��g�{ޅ���&Z3E�8fKX��C��bV0�ײ���z��(�9�����חG��,�G��Q
Å�	vV�\���)�7U�}OiB?H�e���>B�vLV�/���ySi?uƓ�\����e����M�ڍ��fF�O��u>Z��*:� �e
r�BS�&�ƕ�^�3g�#	ɾ�������P՟î0�6ʰ@ �Т�3���+���ԝ_�>���ګpb�e�Y��jfٽ�և�3C�;M�)�3Or��E�UM��W7�K<��xQ�S�� a��2NL���Q"y��Qj��}�s�
�+���d����Vƴ|ҋ雸��y�4�63�g�5�!��b+e��	�_�G�f!`�Y�c���Ð�C+�7���[�[6P�y�qՔ"�oV�d�#ώɔҐn�x��dzԁ��65қ�"C�"B^���qo	��#�y1m��q<Pw�J!����CV�.���_�yx�"��v��[�f��k��������|9Xu����Vg5x�˱l�R7���W�����g��!`9S��o;��G2E�z�k�8x�b(>�`|����5��Ћ��)_I���Ήg�Fy_y��>V�o��t��U|;������B��g+���
�5�De�^��:*;��cY��57)Yy��&���ͳ�z��[��5m��#�� �>캆o��0���
v����5���4������ڼ#��vb`��rA��C�VE�,��%�́\�%;��C�˲����j�)g�6�
u6��'���?rgl�~A��ۄ�8r�Rrk�L�����ڏ;���㳾ݳ����\�®��Ӏ��n	A������JD��sZ"A�f$�5�5
��3��"�`'Q5[��k~��ce
OQ~�D�����DA53���'_%�Yf���m�XxW��9,������Q=�H(���
�#� 0X��lzR�+�C�h^.V�!	iGǼ�~��G~4�M�,�� ��}��	���()^J���2a�L��(	�pQ�V\��0��E ��a��7�o�6�3�7ȏ�0	}��>��@� �I8q��Of�o0���t�T��>U\��{���b��O�'Q0m`�
�m=���������^$�5���N�,*�x�"���HDi#���dZDa`Q�hO;��[U�:�i��h����,�
����  �މ;��"�N����b�W�������<��"��e���5"V�Vi[��L�W�_�
_+#�د��ᘭ�G6����~�g�<�6���������/��s��j�oR�9y�J[�����j��E.-x�\��g�s'r�VͿd��E�	��2_x�ʽo���-����a�!@ _;���Z�
����ˣ�0X��$�_Y5 .���δoRf��	��$EO��"�{�ңN�OrmugUp{�y�aX؏��c���[�Mx���RV3���������Zdf�\$!�e6��F�)�7��!)`;Gߌ�� ا����?��G��EV"�r8�mO�T������h`ʜ%l�i�n�cWO#a+�83j�`r&4��o_��	AY*��Rg��Vi�{dl �N���s�-'`hr�7��Ii����R�]4������u���7?
w������j�	�^�<ufS
��=�=#OL-��>����X���>�eP������֡7)<�a�9��*�p����Q�w
� L\���^1��5�L�*^�{0�,\Rj��]7�O�&�,Y�O�ݔ�[ݤ �5iE������c���^T$b�BZ������η����fL�vYr�o��1�s/D�F
��L~�L[5)��
���>���L�hv*��|�p򧑂+���ȭ�t��c�l���p6��N�A�S��������r)
5GI6�$�#*�����p��/�}��U�(�Xd~��.5���� F0�]h�*5R�5.t���L�M��E�	��S��~F Tʨ[N���ӔV�zd����f���ڶ����	^)q5�Ta���*ض�,�3xZ2����(��Օ{��J��9=޴���+�r���D]-��;�p�y����k����Gn��hf�8f
%RSP�ѳ~�&
��rލ�@ڴt�j2'����ZJ��㳧}�$���H��[ }��ׯ��3���%�� �䒟���@L�����V;!�D<jX��r��`M<�sT�c�D4��j���^d����
%Xx�'o(��y���X�UjW4q�&�yğ��,-����w'�Uq��3���6�b�5���{������>Y�Z��	��� E������R�w'��jP
��6��Q�s=4��O��4�EƾR��|f�Z~�;mO�ˈ\�>��>m�7y�@g��=u��ٱ|M�љ5�w���b��9-�p�0��W5�	� ,;�u�K�g��0�;��p�Sw�0�U/��LK#� �}�cM_��C�+[��r�,�?��n�uT��@WLgа�R'�ܿ�;f^��l�g�s��^��Tc�3>'MF���C��ǆe���;ߡ�S���<⭱�`4U��O���<���_����t��6Y%h��QC�@Ó�����w�� <M��ڜ2c;SXg�3�<ԗ�7w�I��Ϩ��
�:��bn��^^DݽEj��]#G99^>����rx���t�������A �'K����A�2�CS)!g˘���	������V�y*9@@H�\�""҂��������'7������E��|�+$��BM,�������jZ��;ȳ��(�5�Ks#S|�
�j1E�Oy}m�څ��,����n�7��#�W;���Cn�~��b�#���Zɠ�N�[�c��n� ex�0��<s%6����dZEil��m���tQ!����e%V���iD���Bi���,N�{�#�}J���	�� 1cz_Z[��@l�#M��
��,��8��ԛ+��� ��v���?D��agU��>\��u�����t���̡�΁A2�xXnB�Um��W
�y��H�(��z���6��v��y�g�k�8w>{''��ۮ��ˡ���=4���^��GX3vH�
ks�`��b���Ǳ�L��?%�x�Y�T��nbq�����z&���W}�(��9C΋S�zX���s�Ԫ���uL<`�d�gM�p�?�cR^v�'�� KD��O&���b�ӽx/n��V�Q�/Ԡ-Gm9x��?T��(�q;)t�<~��nz6tK����GǏS���
f����1=�-�j�C�C�]�hO� ۘ��T0g�q.ip�2:�-���2�`լ�MX�M���<�{"V�z��h�o>�U��q�-��I�im�R�zm�uNLS�H`�3�>�W� e�s���+���ul���8��8�.�U{{JR�EݒT�8��"�?��'y�k]WH
Rk�nSA/[�#����'��>΋�f��_m����J/ֽ��v'���3�rwGx��=��)K~�5�7�$y>=����Ɩ�rfB�a�Z�༵*�Gd�?'5d�/����p����u��t��nS�v@�>��x6'.�/S��V_�'��8��(�����N����
�DN3E�G��\��[ۭ7�����D�/�Ǌ�9��{
,�%�ٿ���#�>t����*?�8W�N=���Z�n��yPV��&3y<J�����}�ư��LC�s�ݜ��5?S[*s'�A�a��՞�Ezgg8�Ȗ�,c�ڱޏJ6�ЭnCF������p�6J�%������������O␠��.⨦mյ���܇巀G�����R�'��BÓ�ߦ�����&��G�#	�솧��S����Nan�r
��r�k�~�з"
�6�U���v��N6��^V�_N��HI����?�[0��X0�.1=!]6�-�9g�;�JF�-��д�4_��=F@��3�u���ɝ��M>u=o��x��`�B�Yl0SS(��#mId�nv�d�(��#�����Y)�f)��GWM<�5d8A�!��2��:�C/�M�S��!���#"��B��%���3�q�>�縰��>p�<K�r�7qU�Y�
 �7�����C&��{�FPIH)3�H;0��K��$�r	]�&u�п��@U��D���Jף�tes�i?VW������3�!���4jp����?X_������]���y�U�j�f��A�^�zr[�E�y&��ED딈*�w��c��4�P��C�P;�N���gi���>ܰF?T��e����Mw����_�y�5ؤT��?�zk4`���K �G��AN�Ju����z��1vC�^�	U�G`����4o�ϴPM��M��\X�˷}��KBY����u�P}T�"�=��r"�Y��
C?��ރ���Lq�	4f�e|+)��~�Mȟ�������N�iuS�I��Oe���i����?��g�8_��l�a�<2Ěiq�T�g'��ƭ٧�%��b��0��6zR����y-@��"�{�3��߭nB_�L�t3XT�A�n�D�әJIPD�a�F�(oyDh�N�!1di�B�aSk�-;��f�X�v� =�⁥�A:g��>�js�Nϫ`>��FH �"�� �F�. A	G�l$;�ǯ!#�2G���K֩�t�+�['\��`Ը�T����h����oT͏J�m߱��-��HU�&K�M��5�U7�Ta�g����=�NRo�˷M��
NЉ
w�D��0��9�&�4Qk��-�*2�\����H{�r1im��ʆY���teCf��Q�v��D�2����6l0<J�#�B  m�����R�,z9n�Խp��N�r�q'����!GA�f,�g/��?���8��خ�QI��-4����f	�Ŗ�_��IF�;�ۑ��E���9k�����+�N��f+Q�WºH�����V��ڤ���|�-�!��}YJQ�1T�8�N5^)�{�vF}O�<�rD� ]��[�2�,��]��\��մ������5F�_dR����
��	=Yd�E���a�=x�>m�yک ̌m�f����۾C�{�qB��F�S��#z�_��
L���S��y0��B�X.Z�u�]o���>ї�9'
'�B��<��J�G�{;·�m�'�j�����f
�戛)h����2�nJ#�"�)�f$���^n��yM	�(�]6�7������Wj��Fo������BXHޑ���Q� �.6��Ny\	��m���/���Bm�Ǆ#b
GX�
`�BV(x1+
�o5y<�Ď�#����5�a�ﵪc4,F;�V��
}��c{����i1���� �J����J��h���t�</j��|�h�*�1&JEE<���"�(HvA�