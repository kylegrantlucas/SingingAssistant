def create_lambda_function
@settings = RecursiveOpenStruct.new(YAML.load_file('./config/config.yml'))

aws_client = Aws::Lambda::Client.new(
  access_key_id: @settings.aws.access_key_id,
  secret_access_key: @settings.aws.secret_access_key
)

resp = aws_client.create_function({
  function_name: "SingingAssistantRouter",
  runtime: "nodejs",
  role: @settings.aws.iam_role, # required
  handler: "Handler", # required
  code: { # required
    zip_file: "./lambda_router.zip"
  },
  description: "Description",
  timeout: 3,
  memory_size: 128,
  publish: true,
  vpc_config: {
    subnet_ids: ["SubnetId"],
    security_group_ids: ["SecurityGroupId"],
  },
})
end