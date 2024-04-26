## Animations lists

When adding a new set, filenames of new animations must exactly match the original ones (`male_frm.list`, `female_frm.list`). Any difference (using `.fr[0-5]` instead of `.frm` or vice versa) will lead to not recognizing these new files. See [#1](https://github.com/BGforgeNet/Fallout2_Hero_Appearance/issues/1) for details.

At this moment, certain frames are missing in male sets and Punk Girl one:

```diff
diff -u male_frm.list ms01.list  | grep '^-'
--- male_frm.list	2020-02-29 19:37:48.593027328 +0700
-hmjmpsgg.frm
-hmjmpsna.frm
-hmlthrau.frm
-hmmetlau.frm

diff -u male_frm.list ms02.list  | grep '^-'
--- male_frm.list	2020-02-29 19:37:48.593027328 +0700
-hmjmpsgg.frm
-hmjmpsna.frm
-hmlthrau.frm
-hmmetlau.frm

diff -u female_frm.list fs03.list | grep '^-'
--- female_frm.list	2020-02-29 19:37:48.593027328 +0700
-hfjmpsgg.frm
```
