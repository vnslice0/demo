elementclass Cdpf2 {
    isIp :: Classifier(12/0800, -);
    isCdpf :: IPClassifier(dst udp port 9876, -);
    Discard0 :: Discard();
    CheckIPHeader0 :: CheckIPHeader(14, CHECKSUM false);
    CheckUDPHeader0 :: CheckUDPHeader(VERBOSE true);
    Cdpf0 :: Cdpf(configfile './cdpf.conf');

    input -> isIp;
    isIp[1] -> Discard0;
    isCdpf[1] -> Discard0;
    isIp -> CheckIPHeader0;
    CheckIPHeader0 -> CheckUDPHeader0;
    CheckUDPHeader0 -> isCdpf;
    isCdpf -> Cdpf0;
 } 

Cdpf20 :: Cdpf2();
FromDevice0 :: FromDevice(vlan350);

FromDevice0 -> Cdpf20;
