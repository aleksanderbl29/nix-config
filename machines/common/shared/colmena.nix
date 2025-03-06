{
  name,
  ...
}:
{
  deployment.targetHost = name;
  deployment = {
    targetUser = "root";
    buildOnTarget = true;
  };
}
