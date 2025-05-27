{
  publicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP2EFXpXri1rQwyhrZbdJ9lHu96NdYZApVjfbdFY4Jca stefan@nauvis"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvezkFdF7c5cSDYGiDPCVhq/Qhni+QOS9m/BMdPX82y stefan@aquilo"
  ];

  users = [
    nauvis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP2EFXpXri1rQwyhrZbdJ9lHu96NdYZApVjfbdFY4Jca stefan@nauvis";
    aquilo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvezkFdF7c5cSDYGiDPCVhq/Qhni+QOS9m/BMdPX82y stefan@aquilo";
  ];

  systems = [
    nauvis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA08w+wqyBTZJtK0roQtOuc3Ly8PBIT10SRFGqiuElrP root@nauvis";
  ];
}
