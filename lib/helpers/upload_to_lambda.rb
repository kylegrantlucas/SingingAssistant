require 'aws-sdk'
require 'recursive-open-struct'
require 'yaml'

def create_lambda_function
  @settings = RecursiveOpenStruct.new(YAML.load_file('./config/config.yml'))

  Aws.config.update(credentials: Aws::Credentials.new(@settings.aws.access_key_id,@settings.aws.secret_access_key), region: 'us-east-1')

  lambda_client = Aws::Lambda::Client.new

  trust_role_policy = <<-DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
                      DOC

  policy_document = <<-DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
                    DOC
  function = lambda_client.get_function(function_name: "SingingAssistantRouter")

  if function
  else
    iam_client = Aws::IAM::Client.new
    role = iam_client.create_role(user_name: 'singing_assistant_execution',assume_role_policy_document: trust_role_policy).role

    iam_client.put_role_policy(role_name: 'singing_assistant_execution', policy_name:"lambda_execution", policy_document: policy_document)

    function = lambda_client.create_function({
      function_name: "SingingAssistantRouter",
      runtime: "nodejs",
      role: role.arn, # required
      handler: "index.handler", # required
      code: { # required
        zip_file: File.read("./index.zip")
      },
      description: "Description",
      timeout: 3,
      memory_size: 128,
      publish: true
    })
  end
  
  puts resp.function_arn
end