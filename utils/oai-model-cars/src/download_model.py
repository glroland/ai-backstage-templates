import os
import click
from huggingface_hub import snapshot_download

@click.command()
@click.argument('model_repo')
@click.option('--output_dir', help="Where to save the model files", default=".")
def main(model_repo, output_dir):
    """ Downloads MODEL_REPO from HuggingFace and saves to the specified output directory.
    
        model_repo - HF Repo ID
        output_dir - Where to save model weights
    """

    # validate arguments
    if len(model_repo) == 0:
        raise ValueError("Model Repo Argument is required!")
    if len(output_dir) == 0:
        raise ValueError("Output Directory Argument is required!")
    print ("Model Repo: ", model_repo)
    print ("Output Directory: ", output_dir)

    # ensure output directory actually exists
    if not os.path.isdir(output_dir):
        raise ValueError(f"Output Directory {output_dir} does not exist")

    # download model files
    print ("Downloading model weights from HuggingFace...")
    snapshot_download(
        repo_id=model_repo,
        local_dir=output_dir,
        allow_patterns=["*.safetensors", "*.json", "*.txt", "*.gguf"],
    )
    print ("Complete!")

if __name__ == '__main__':
    main()
